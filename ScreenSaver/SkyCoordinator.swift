//
//  SkyCoordinator.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/10/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

// The SkyCoordinator class manages the screen between the various views of night/day/sunrise/sunset.

protocol SkyCoordinatorDelegate {
    func shouldAddSubview(_ view: NSView, below: NSView?)
}

final class SkyCoordinator: NSObject {
    
    private var skyMode: SkyMode? {
        didSet {
            if skyMode != oldValue {
                currentView = createCurrentView()
            }
        }
    }
    private var nextTransition: Transition?
    
    var currentView: AnimatableView? {
        didSet {
            if let currentView = currentView {
                delegate?.shouldAddSubview(currentView, below: oldValue)
            }
            oldValue?.removeFromSuperviewWithAnimation()
        }
    }
    
    var delegate: SkyCoordinatorDelegate?
    
    private let transitionForecaster = TransitionForecaster()
        
    func startAnimation() {
        transitionForecaster.delegate = self
        
        if skyMode == nil {
            refreshSkyMode()
        }
    }

    func animateOneFrame() {
        currentView?.animateOneFrame()

        if let nextTransition = nextTransition,
            nextTransition.date.isNowOrInThePast() {
                skyMode = nextTransition.skyMode
                self.nextTransition = nil
        }
    }
    
    func refreshSkyMode() {
        transitionForecaster.start()
    }
    
    func createCurrentView() -> AnimatableView? {
        guard let skyMode = skyMode else { return nil }
        
        switch skyMode {
            case .sunrise:
                let tv = TransitionView(type: .sunrise)
                tv.delegate = self
                return tv
            
            case .day:
                return DayView()
            
            case .sunset:
                let tv = TransitionView(type: .sunset)
                tv.delegate = self
                return tv
            
            case .night:
                return NightView()
        }
    }
    
    func didClick() {
        // useful for debugging
    }
}

extension SkyCoordinator: TransitionForecasterDelegate {
    func shouldUpdateToCurrentSkyMode(_ skyMode: SkyMode) {
        self.skyMode = skyMode
    }
    
    func shouldPlanForNextTransition(_ skyMode: SkyMode, at date: Date) {
        self.nextTransition = Transition(skyMode: skyMode, date: date)
    }
    
    func didFail(error: Error?) {
        //todo: handle fail.
    }
}

extension SkyCoordinator: TransitionViewDelegate {
    func didComplete() {
        skyMode = skyMode?.next()
    }
}
