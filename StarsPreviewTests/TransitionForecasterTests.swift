//
//  TransitionForecasterTests.swift
//  StarsPreviewTests
//
//  Created by Robert Tolar Haining on 5/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import SkySaverPreview
import CoreLocation

// let's see if our forecaster is calculating the next transition correctly

class TransitionForecasterTests: XCTestCase {

    override func setUpWithError() throws {
        transitionForecaster = TransitionForecaster()

        currentSkyModeExpectation = expectation(description: "current sky mode")
        nextTransitionExpectation = expectation(description: "next transition")
    }

    override func tearDownWithError() throws {}

    var transitionForecaster: TransitionForecaster!
    var currentSkyModeExpectation: XCTestExpectation!
    var nextTransitionExpectation: XCTestExpectation!
    
    var expectedCurrentSkyMode: SkyMode?
    var expectedNextTransitionSkyMode: SkyMode?
    var expectedNextTransitionDate: Date?
    
    let midday = Date(timeIntervalSinceReferenceDate: 72000)
    let sunset = Date(timeIntervalSinceReferenceDate: 78088)
    let midSunset = Date(timeIntervalSinceReferenceDate: 78268)
    let night = Date(timeIntervalSinceReferenceDate: 10)
    let sunrise = Date(timeIntervalSinceReferenceDate: 44408)
    let midSunrise = Date(timeIntervalSinceReferenceDate: 44568)

    func testNight() throws {
        expectedCurrentSkyMode = .night
        expectedNextTransitionSkyMode = .sunrise
        expectedNextTransitionDate = sunrise
        
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: night, coordinate: CityCoordinates.nyc)
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }
    
    func testSunset() throws {
        expectedCurrentSkyMode = .sunset
        
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: sunset, coordinate: CityCoordinates.nyc)
        
        nextTransitionExpectation.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }
    
    func testMidSunset() throws {
        expectedCurrentSkyMode = .sunset
        
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: midSunset, coordinate: CityCoordinates.nyc)
        
        nextTransitionExpectation.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }

    func testDay() throws {
        expectedCurrentSkyMode = .day
        expectedNextTransitionSkyMode = .sunset
        expectedNextTransitionDate = sunset

        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: midday, coordinate: CityCoordinates.nyc)
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }

    func testSunrise() throws {
        expectedCurrentSkyMode = .sunrise
        
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: sunrise, coordinate: CityCoordinates.nyc)
        
        nextTransitionExpectation.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }
    func testMidSunrise() throws {
        expectedCurrentSkyMode = .sunrise
        
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: midSunrise, coordinate: CityCoordinates.nyc)
        
        nextTransitionExpectation.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(String(describing: error?.localizedDescription))")
        }
    }
}

extension TransitionForecasterTests: TransitionForecasterDelegate {
    func shouldUpdateToCurrentSkyMode(_ skyMode: SkyMode) {
        XCTAssert(skyMode == expectedCurrentSkyMode,
                  "current skyMode fail: \(skyMode) != \(expectedCurrentSkyMode!)")
        currentSkyModeExpectation.fulfill()
    }
    
    func shouldPlanForNextTransition(_ skyMode: SkyMode, at date: Date) {
        XCTAssert(skyMode == expectedNextTransitionSkyMode,
                  "next skyMode fail: \(skyMode) != \(expectedNextTransitionSkyMode!)")
        XCTAssert(abs(date.timeIntervalSince(expectedNextTransitionDate!)) < 300,
                  "next transition date fail: \(date) != \(expectedNextTransitionDate!)")
        nextTransitionExpectation.fulfill()
    }
    
    func didFail(error: Error?) {
        NSLog("did fail \(String(describing: error?.localizedDescription))")
    }
}

