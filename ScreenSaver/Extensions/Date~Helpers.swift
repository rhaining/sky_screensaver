//
//  Date~Helpers.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 6/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

//
// Convenience methods for relative dates.
//

public extension Date {
    func wasRecent(from date: Date = Date()) -> Bool {
        return self.timeIntervalSince(date) >= -3600
    }
    
    func isNowOrInThePast(from date: Date = Date()) -> Bool {
        return self.compare(date) != .orderedDescending
    }
    
    func isPast(from date: Date = Date()) -> Bool {
        return self.compare(date) == .orderedAscending
    }
    
    func isInTheFuture(from date: Date = Date()) -> Bool {
        return self.compare(date) == .orderedDescending
    }
    
    var justAfterMidnight: Date? {
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: self) {
            let tomorrowJustAfterMidnight = calendar.startOfDay(for: tomorrow)
            return tomorrowJustAfterMidnight
        } else {
            return nil
        }
    }
}
