//
//  SkyCoordinator.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/10/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

protocol SkyView: NSView {
    func animateOneFrame()
}

protocol SkyCoordinatorDelegate {
    func shouldAddSubview(_ view: NSView, below: NSView?)
}

struct Transition {
    let skyMode: SkyMode
    let date: Date
}

final class SkyCoordinator {
    
    var skyMode: SkyMode? {
        didSet {
            if skyMode != oldValue {
                currentView = createCurrentView()
            }
        }
    }
    var nextTransition: Transition?
    
    var currentView: SkyView? {
        didSet {
            if let currentView = currentView {
                delegate?.shouldAddSubview(currentView, below: oldValue)
            }
            oldValue?.removeFromSuperviewWithAnimation()
        }
    }
    
    var delegate: SkyCoordinatorDelegate?
    
    let transitionForecaster = TransitionForecaster()
    
    
    init() {
        transitionForecaster.delegate = self
    }
    
    func startAnimation() {
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
    
    func createCurrentView() -> SkyView? {
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
    
    // debugging…
    func didClick() {
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
