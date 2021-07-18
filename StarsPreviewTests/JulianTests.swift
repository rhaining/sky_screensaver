//
//  JulianTests.swift
//  SkySaverPreviewTests
//
//  Created by Robert Tolar Haining on 6/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import SkySaverPreview

//
// This julian calendar is a little new to me. is it working right? yep!
//

class JulianTests: XCTestCase {
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .long
        return df
    }()

    func testDaysSinceY2K() throws {
        let days = Julian.daysSinceY2KNoon(for: Date(timeIntervalSinceReferenceDate: 0))
        XCTAssert(Int(round(days)) == 365, "\(days) not 365")
    }
    
    func testJulianDays() throws {
        let days = 2455382.5
        let date = Julian.dateForJulianDays(julianDays: days)
        XCTAssert(dateFormatter.string(from: date) == "July 4, 2010 at 12:00:00 PM EDT", "date should be july 4: \(date)")

    }
}
