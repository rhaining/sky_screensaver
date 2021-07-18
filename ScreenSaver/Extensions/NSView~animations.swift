//
//  NSView~animations.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/10/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// Add or remove subviews with a basic opacity animation (fade-in or fade-out).
//

extension NSView {
    
    func addSubviewWithAnimation(_ view: NSView) {
        let animationDuration = 5
        view.wantsLayer = true
        view.layer?.opacity = 0
        
        addSubview(view)

        CATransaction.begin()
        CATransaction.setAnimationDuration(Double(animationDuration))
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let alphaAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        
        view.layer?.opacity = 1
        
        view.layer?.add(alphaAnimation, forKey: #keyPath(CALayer.opacity))
        
        CATransaction.commit()        
    }
    func removeFromSuperviewWithAnimation() {
        wantsLayer = true
        
        let animationDuration = 5
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(Double(animationDuration))
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let alphaAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        layer?.opacity = 0
        
        layer?.add(alphaAnimation, forKey: #keyPath(CALayer.opacity))
        
        CATransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(animationDuration)) { [weak self] in
            self?.removeFromSuperview()
        }
    }

}
