//
//  DateExtensionTests.swift
//  SkySaverPreviewTests
//
//  Created by Robert Tolar Haining on 6/6/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest

class DateExtensionTests: XCTestCase {

    func testWasRecentSuccess() throws {
        let d = Date(timeIntervalSinceNow: -500)
        XCTAssert(d.wasRecent())
    }
    func testWasRecentFail() throws {
        let d = Date(timeIntervalSinceNow: -9999)
        XCTAssert(!d.wasRecent())
    }

    func testIsNowOrInThePastSuccessNow() throws {
        let d = Date(timeIntervalSinceNow: 0)
        XCTAssert(d.isNowOrInThePast())
    }
    func testIsNowOrInThePastSuccessPast() throws {
        let d = Date(timeIntervalSinceNow: -500)
        XCTAssert(d.isNowOrInThePast())
    }
    func testIsNowOrInThePastFail() throws {
        let d = Date(timeIntervalSinceNow: 500)
        XCTAssert(!d.isNowOrInThePast())
    }
    
    func testIsPastFailNow() throws {
        let d = Date(timeIntervalSinceNow: 0)
        XCTAssert(d.isPast())
    }
    func testIsPastSuccessPast() throws {
        let d = Date(timeIntervalSinceNow: -500)
        XCTAssert(d.isPast())
    }
    func testIsPastFail() throws {
        let d = Date(timeIntervalSinceNow: 500)
        XCTAssert(!d.isPast())
    }
    
    func testIsInTheFutureFailNow() throws {
        let d = Date(timeIntervalSinceNow: 0)
        XCTAssert(!d.isInTheFuture())
    }
    func testIsInTheFutureSuccess() throws {
        let d = Date(timeIntervalSinceNow: 500)
        XCTAssert(d.isInTheFuture())
    }
    func testIsInTheFutureFail() throws {
        let d = Date(timeIntervalSinceNow: -500)
        XCTAssert(!d.isInTheFuture())
    }
    
    func testJustAfterMidnight() throws {
        let d = Date(timeIntervalSinceReferenceDate: 500)
        let justAfterMidnight = Date(timeIntervalSinceReferenceDate: 18000)
        XCTAssert(d.justAfterMidnight == justAfterMidnight)
    }
}
