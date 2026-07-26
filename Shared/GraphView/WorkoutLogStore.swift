//
//  WorkoutLogStore.swift
//  MuscleTrainingCounter
//
//  種目ごとの記録を「日付キー辞書（yyyy-MM-dd → 合計回数）」で全履歴保存し、
//  日・週・月の集計とページ送りを提供するデータ層。
//

import Foundation

/// グラフ1画面ぶんの集計結果。
struct WorkoutSeries {
    let values: [Int]       // 左が古く右が新しい。day=7 / week=4 / month=6 要素
    let labels: [String]    // 各棒の軸ラベル（曜日 / 週開始日 / 月名）
    let rangeTitle: String  // 表示中の期間タイトル（例 "7/20 - 7/26"）
    let hasOlderData: Bool  // これより過去にデータがあるか（左矢印の有効判定）
}

final class WorkoutLogStore {
    static let shared = WorkoutLogStore()

    private let ud = UserDefaults.standard

    // 各期間で表示する本数
    private let dayCount = 7
    private let weekCount = 4
    private let monthCount = 6

    /// 日付キー生成用の固定フォーマッタ（ロケール/TZ揺れを排除）。
    private lazy var keyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.calendar = Calendar.current
        f.timeZone = Calendar.current.timeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private var calendar: Calendar { Calendar.current }

    private init() {}

    // MARK: - 日付キー

    private func key(for date: Date) -> String {
        keyFormatter.string(from: date)
    }

    // MARK: - 辞書の read / write

    func dailyDictionary(for type: TrainingType) -> [String: Int] {
        guard let data = ud.data(forKey: type.dailyLogKey),
              let dict = try? JSONDecoder().decode([String: Int].self, from: data) else {
            return [:]
        }
        return dict
    }

    private func save(_ dict: [String: Int], for type: TrainingType) {
        if let data = try? JSONEncoder().encode(dict) {
            ud.set(data, forKey: type.dailyLogKey)
        }
    }

    // MARK: - 保存（加算）

    /// 指定日（既定は今日）の記録に count を加算する。同日複数回の保存は累積される。
    func addCount(_ count: Int, to type: TrainingType, on date: Date = Date()) {
        guard count != 0 else { return }
        var dict = dailyDictionary(for: type)
        let k = key(for: date)
        dict[k, default: 0] += count
        save(dict, for: type)
    }

    /// 単日の値。
    func value(for type: TrainingType, on date: Date) -> Int {
        dailyDictionary(for: type)[key(for: date)] ?? 0
    }

    // MARK: - 集計（グラフ表示用）

    /// pageOffset: 0=最新の期間、-1=1つ前、... （過去方向へ負）
    func series(type: TrainingType, span: SpanType, pageOffset: Int) -> WorkoutSeries {
        switch span {
        case .day:   return daySeries(type: type, pageOffset: pageOffset)
        case .week:  return weekSeries(type: type, pageOffset: pageOffset)
        case .month: return monthSeries(type: type, pageOffset: pageOffset)
        }
    }

    // 日: 暦週単位（1ページ=その週の7日）
    private func daySeries(type: TrainingType, pageOffset: Int) -> WorkoutSeries {
        let dict = dailyDictionary(for: type)
        // 対象週の開始日（今週から pageOffset 週ずらす）
        let thisWeekStart = startOfWeek(for: Date())
        let weekStart = calendar.date(byAdding: .weekOfYear, value: pageOffset, to: thisWeekStart)!

        var values: [Int] = []
        var labels: [String] = []
        for i in 0..<dayCount {
            let day = calendar.date(byAdding: .day, value: i, to: weekStart)!
            values.append(dict[key(for: day)] ?? 0)
            labels.append(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: day) - 1])
        }
        let weekEnd = calendar.date(byAdding: .day, value: dayCount - 1, to: weekStart)!
        let title = "\(shortDate(weekStart)) - \(shortDate(weekEnd))"
        return WorkoutSeries(values: values, labels: labels, rangeTitle: title,
                             hasOlderData: hasData(before: weekStart, in: dict))
    }

    // 週: 暦週で4週分（1ページ=直近4週のブロック）
    private func weekSeries(type: TrainingType, pageOffset: Int) -> WorkoutSeries {
        let dict = dailyDictionary(for: type)
        let thisWeekStart = startOfWeek(for: Date())
        // 右端の週（最新ブロックの一番新しい週）を pageOffset×weekCount 週ずらす
        let rightMostWeekStart = calendar.date(byAdding: .weekOfYear,
                                               value: pageOffset * weekCount, to: thisWeekStart)!
        var values: [Int] = []
        var labels: [String] = []
        var oldestStart = rightMostWeekStart
        for i in stride(from: weekCount - 1, through: 0, by: -1) {
            let wStart = calendar.date(byAdding: .weekOfYear, value: -i, to: rightMostWeekStart)!
            oldestStart = min(oldestStart, wStart)
            let wEnd = calendar.date(byAdding: .day, value: 6, to: wStart)!
            values.append(sum(in: dict, from: wStart, to: wEnd))
            labels.append(shortDate(wStart))
        }
        let rightEnd = calendar.date(byAdding: .day, value: 6, to: rightMostWeekStart)!
        let title = "\(shortDate(oldestStart)) - \(shortDate(rightEnd))"
        return WorkoutSeries(values: values, labels: labels, rangeTitle: title,
                             hasOlderData: hasData(before: oldestStart, in: dict))
    }

    // 月: 暦月で6ヶ月分
    private func monthSeries(type: TrainingType, pageOffset: Int) -> WorkoutSeries {
        let dict = dailyDictionary(for: type)
        let thisMonthStart = startOfMonth(for: Date())
        let rightMostMonthStart = calendar.date(byAdding: .month,
                                                value: pageOffset * monthCount, to: thisMonthStart)!
        var values: [Int] = []
        var labels: [String] = []
        var oldestStart = rightMostMonthStart
        for i in stride(from: monthCount - 1, through: 0, by: -1) {
            let mStart = calendar.date(byAdding: .month, value: -i, to: rightMostMonthStart)!
            oldestStart = min(oldestStart, mStart)
            let mEnd = endOfMonth(for: mStart)
            values.append(sum(in: dict, from: mStart, to: mEnd))
            labels.append(calendar.shortMonthSymbols[calendar.component(.month, from: mStart) - 1])
        }
        let title = "\(monthTitle(oldestStart)) - \(monthTitle(rightMostMonthStart))"
        return WorkoutSeries(values: values, labels: labels, rangeTitle: title,
                             hasOlderData: hasData(before: oldestStart, in: dict))
    }

    // MARK: - 集計ヘルパー

    private func sum(in dict: [String: Int], from start: Date, to end: Date) -> Int {
        var total = 0
        var day = calendar.startOfDay(for: start)
        let last = calendar.startOfDay(for: end)
        while day <= last {
            total += dict[key(for: day)] ?? 0
            day = calendar.date(byAdding: .day, value: 1, to: day)!
        }
        return total
    }

    /// 指定日より前にデータ（>0）があるか。
    private func hasData(before date: Date, in dict: [String: Int]) -> Bool {
        let boundary = key(for: date)
        for (k, v) in dict where v > 0 && k < boundary {
            return true
        }
        return false
    }

    // MARK: - 暦の境界

    private func startOfWeek(for date: Date) -> Date {
        // firstWeekday を尊重して週の頭を自前で求める（dateInterval はロケール次第で不安定なため）。
        let startOfDay = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: startOfDay) // 1=日
        var diff = weekday - calendar.firstWeekday
        if diff < 0 { diff += 7 }
        return calendar.date(byAdding: .day, value: -diff, to: startOfDay)!
    }

    private func startOfMonth(for date: Date) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps) ?? calendar.startOfDay(for: date)
    }

    private func endOfMonth(for date: Date) -> Date {
        let start = startOfMonth(for: date)
        let next = calendar.date(byAdding: .month, value: 1, to: start)!
        return calendar.date(byAdding: .day, value: -1, to: next)!
    }

    // MARK: - ラベル整形

    private func shortDate(_ date: Date) -> String {
        let m = calendar.component(.month, from: date)
        let d = calendar.component(.day, from: date)
        return "\(m)/\(d)"
    }

    private func monthTitle(_ date: Date) -> String {
        calendar.shortMonthSymbols[calendar.component(.month, from: date) - 1]
    }

    // MARK: - 旧データの移行

    /// 旧 NumArray 配列（末尾 index7 = today、左へ過去）を日付キー辞書へ一度だけ移行する。
    func migrateLegacyArraysIfNeeded() {
        guard !ud.bool(forKey: "migratedToDailyLog") else { return }

        for type in TrainingType.allCases {
            guard let legacyToday = ud.object(forKey: type.legacyTodayKey) as? Date,
                  let legacyArray = ud.array(forKey: type.legacyDayKey) as? [Double] else {
                continue
            }
            // 旧日次配列は saveLength=7。描画に使うのは index 1...7（右端 index7 = today）。
            // index7→today(0日前), index6→1日前, ... index1→6日前 に対応する。
            var dict = dailyDictionary(for: type)
            let saveLength = 7
            for index in 1...saveLength {
                guard index < legacyArray.count else { continue }
                let value = Int(legacyArray[index])
                guard value > 0 else { continue }
                let daysAgo = saveLength - index  // index7→0, index1→6
                let date = calendar.date(byAdding: .day, value: -daysAgo, to: legacyToday)!
                let k = key(for: date)
                // 既に新方式で保存があればそちらを優先（上書きしない）。
                if dict[k] == nil {
                    dict[k] = value
                }
            }
            save(dict, for: type)
        }

        ud.set(true, forKey: "migratedToDailyLog")
    }
}
