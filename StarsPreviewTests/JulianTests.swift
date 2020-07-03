//
//  JulianTests.swift
//  SkySaverPreviewTests
//
//  Created by Robert Tolar Haining on 6/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import SkySaverPreview

class JulianTests: XCTestCase {
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .long
        return df
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
