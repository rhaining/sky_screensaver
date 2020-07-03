StarsPreviewTests/StarsPreviewTests.swift//
//  TransitionForecasterTests.swift
//  StarsPreviewTests
//
//  Created by Robert Tolar Haining on 5/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import XCTest
@testable import SkySaverPreview
import CoreLocation

class TransitionForecasterTests: XCTestCase {

    override func setUpWithError() throws {
        expectation = expectation(description: "tacos")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    let transitionForecaster = TransitionForecaster()
    var expectation: XCTestExpectation!
    
    func testExample() throws {
        transitionForecaster.delegate = self
        transitionForecaster.getSolar(for: Date(timeIntervalSinceReferenceDate: 0),
                                coordinate: CLLocationCoordinate2D(latitude: 40.7, longitude: -73.9))
        
        waitForExpectations(timeout: 10) { error in
            NSLog("waitForExpectations error \(error?.localizedDescription)")
        }
    }

}

extension TransitionForecasterTests: TransitionForecasterDelegate {
    func shouldUpdateToCurrentSkyMode(_ skyMode: SkyMode) {
        NSLog("skymode = \(skyMode)")
        XCTAssert(skyMode == .night)
        expectation.fulfill()
    }
    
    func shouldPlanForNextTransition(_ skyMode: SkyMode, at date: Date) {
        NSLog("next transition  = \(skyMode) @ \(date)")
        
    }
    
    func didFail(error: Error?) {
        NSLog("did fail \(error?.localizedDescription)")
    }
}

