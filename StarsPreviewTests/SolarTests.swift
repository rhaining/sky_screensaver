//
//  SolarTests.swift
//  SkySaverPreviewTests
//
//  Created by Robert Tolar Haining on 6/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import SkySaverPreview
import CoreLocation

class SolarTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = .current
        df.dateStyle = .medium
        df.timeStyle = .long
        return df
    }()
    
    let june7_2020 = Date(timeIntervalSinceReferenceDate: 7098 * 24 * 60 * 60.0)
    let january7_2020 = Date(timeIntervalSinceReferenceDate: 6946 * 24 * 60 * 60.0)
    
    func genericTest(date: Date, coordinate: CLLocationCoordinate2D, expectedSunriseDesc: String, expectedSunsetDesc: String) {
        let solar = Solar(for: date, coordinate: coordinate)!

        let expectedSunrise = dateFormatter.date(from: expectedSunriseDesc)!
        let sunriseDelta = abs(solar.sunrise!.timeIntervalSinceNow - expectedSunrise.timeIntervalSinceNow)

        let expectedSunset = dateFormatter.date(from: expectedSunsetDesc)!
        let sunsetDelta = abs(solar.sunset!.timeIntervalSinceNow - expectedSunset.timeIntervalSinceNow)

        let calculatedSunrise = dateFormatter.string(from: solar.sunrise!)
        let calculatedSunset = dateFormatter.string(from: solar.sunset!)
        
        let thresholdToCare = 300.0

        XCTAssertTrue(sunriseDelta < thresholdToCare,
                      "sunrise fail: \(calculatedSunrise) != \(expectedSunrise) - delta=\(sunriseDelta)")
        XCTAssertTrue(sunsetDelta < thresholdToCare,
                      "sunset fail: \(calculatedSunset) != \(expectedSunset) - delta=\(sunsetDelta)")
    }

    func testNYCJune() throws {
        genericTest(date: june7_2020,
                    coordinate: CityCoordinates.nyc,
                    expectedSunriseDesc: "Jun 7, 2020 at 5:24:00 AM EDT",
                    expectedSunsetDesc: "Jun 7, 2020 at 8:25:00 PM EDT")
    }
    
    func testNYCJanuary() throws {
        genericTest(date: january7_2020,
                    coordinate: CityCoordinates.nyc,
                    expectedSunriseDesc: "Jan 7, 2020 at 7:20:00 AM EST",
                    expectedSunsetDesc: "Jan 7, 2020 at 4:43:00 PM EST")
    }
    
    func testAtlantaJune() throws {
        genericTest(date: june7_2020,
                    coordinate: CityCoordinates.atlanta,
                    expectedSunriseDesc: "Jun 7, 2020 at 6:26:00 AM EDT",
                    expectedSunsetDesc: "Jun 7, 2020 at 8:46:00 PM EDT")
    }
    
    func testAtlantaJanuary() throws {
        genericTest(date: january7_2020,
                    coordinate: CityCoordinates.atlanta,
                    expectedSunriseDesc: "Jan 7, 2020 at 7:42:00 AM EST",
                    expectedSunsetDesc: "Jan 7, 2020 at 5:44:00 PM EST")
    }
    
    func testSFJune() throws {
        genericTest(date: june7_2020,
                    coordinate: CityCoordinates.sf,
                    expectedSunriseDesc: "Jun 7, 2020 at 5:48:00 AM PDT",
                    expectedSunsetDesc: "Jun 7, 2020 at 8:30:00 PM PDT")
    }
    
    func testSFJanuary() throws {
        genericTest(date: january7_2020,
                    coordinate: CityCoordinates.sf,
                    expectedSunriseDesc: "Jan 7, 2020 at 7:25:00 AM PST",
                    expectedSunsetDesc: "Jan 7, 2020 at 5:07:00 PM PST")
    }
    
    func testVeniceJune() throws {
        genericTest(date: june7_2020,
                    coordinate: CityCoordinates.venice,
                    expectedSunriseDesc: "Jun 7, 2020 at 5:23:00 AM GMT+2",
                    expectedSunsetDesc: "Jun 7, 2020 at 8:56:00 PM GMT+2")
    }
    
    func testVeniceJanuary() throws {
        genericTest(date: january7_2020,
                    coordinate: CityCoordinates.venice,
                    expectedSunriseDesc: "Jan 7, 2020 at 7:50:00 AM GMT+1",
                    expectedSunsetDesc: "Jan 7, 2020 at 4:44:00 PM GMT+1")
    }
    
    
    func testMelbourneJune() throws {
        genericTest(date: june7_2020,
                    coordinate: CityCoordinates.melbourne,
                    expectedSunriseDesc: "Jun 7, 2020 at 6:55:00 AM GMT+10",
                    expectedSunsetDesc: "Jun 7, 2020 at 4:53:00 PM GMT+10")
    }
    
    func testMelbourneJanuary() throws {
        genericTest(date: january7_2020,
                    coordinate: CityCoordinates.melbourne,
                    expectedSunriseDesc: "Jan 7, 2020 at 5:52:00 AM GMT+11",
                    expectedSunsetDesc: "Jan 7, 2020 at 8:10:00 PM GMT+11")
    }
    
}
