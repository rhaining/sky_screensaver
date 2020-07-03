//
//  Julian.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 6/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct Julian {
    private static let julianFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "g"
        return df
    }()
    
    private static let equivalentJulianYear = 2451545.0 //Jan 1, 2000 @ 12:00
    private static let fractionalJulianDayForLeapSeconds = 0.0//0.0008 //~1 minute or so
    private static let secondsIn2000 = 366.0 * 24 * 60 * 60
    private static let secondsInDay = 24.0 * 60 * 60
    private static let secondsInHour = 60.0 * 60
    
    static func julianDateNoon(from date: Date) -> Double {
        let jDateStr = julianFormatter.string(from: date)
        let jDateMidnight = Double(jDateStr)!
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date)) / secondsInDay
        let jDateNoon = jDateMidnight + 0.5 + timeZoneOffset
        return jDateNoon
    }

    static func daysSinceY2KNoon(for date: Date) -> Double {
        //  n is the number of days since Jan 1st, 2000 12:00.
        let jDate = julianDateNoon(from: date)
        let n = jDate - equivalentJulianYear + fractionalJulianDayForLeapSeconds
        return n
    }

    static func dateForJulianDays(julianDays: Double) -> Date {
        var date = julianFormatter.date(from: "\(Int(floor(julianDays)))")!
        let fractionalDay = julianDays - floor(julianDays)
        date.addTimeInterval(fractionalDay * secondsInDay)
        return date
    }
}
