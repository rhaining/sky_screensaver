//
//  PreviewViewController.swift
//  StarsPreview
//
//  Created by Robert Tolar Haining on 5/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// This view controller allows us to preview the screensaver and simulates the animation timer.
//

final class PreviewViewController: NSViewController {
    var screensaverView: SkySaverView? = nil
    
    var timer: Timer? = nil
    
    var isAnimating: Bool = false {
        didSet {
            toggleAnimationTimer()
        }
    }
    
    override func loadView() {
        screensaverView = SkySaverView(frame: CGRect.zero, isPreview: true)
        screensaverView?.startAnimation()
        self.view = screensaverView ?? NSView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        isAnimating = true
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        isAnimating = false
    }
    
    private func toggleAnimationTimer() {
        if isAnimating {
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: screensaverView!.animationTimeInterval, repeats: true) { [weak self] (_) in
                    self?.animate()
                }
            }
        } else {
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    func animate() {
        if isAnimating, let screensaverView = screensaverView {
            screensaverView.animateOneFrame()
        }
    }
}
