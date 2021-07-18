//
//  SkySaverView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import ScreenSaver

//
// Our primary screensaver class. This is what macOS will instantiate to start our screensaver.
//

final class SkySaverView: ScreenSaverView {
    private let skyCoordinator = SkyCoordinator()

    override init?(frame: CGRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1 / 30.0
        
        skyCoordinator.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        super.startAnimation()
        skyCoordinator.startAnimation()
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        skyCoordinator.currentView?.frame = bounds
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        skyCoordinator.animateOneFrame()
    }
    
    override var acceptsFirstResponder: Bool { return true }
        
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        skyCoordinator.didClick()
    }
}

extension SkySaverView: SkyCoordinatorDelegate {
    func shouldAddSubview(_ view: NSView, below topView: NSView?) {
        view.frame = bounds
        if let topView = topView {
            addSubview(view, positioned: .below, relativeTo: topView)
        } else {
            addSubview(view)
        }
    }
}
