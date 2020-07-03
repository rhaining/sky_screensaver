//
//  TransitionView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

protocol TransitionViewDelegate {
    func didComplete()
}

final class TransitionView: NSView {
    enum TransitionType {
        case sunrise, sunset
    }
    
    var delegate: TransitionViewDelegate?
    
    let type: TransitionType
    
    var isComplete = false {
        didSet {
            if isComplete {
                delegate?.didComplete()
            }
        }
    }
    
    let gradientLayer = CAGradientLayer()
    let gradientColors: [CGColor]

    init(type: TransitionType) {
        self.type = type
        
        switch type {
            case .sunrise:
                gradientLayer.colors = [ColorHelper.nighttime, ColorHelper.nighttime]
                gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
                gradientColors = ColorHelper.sunrise
            case .sunset:
                gradientLayer.colors = [ColorHelper.daytime, ColorHelper.daytime]
                gradientColors = ColorHelper.sunset
        }

        super.init(frame: .zero)
        
        wantsLayer = true
        layer?.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        gradientLayer.frame = bounds
    }
    
    var hasStarted = false
    func startTransitions() {
        guard !hasStarted else { return }
        hasStarted = true
        
        transitionToNextStop()
    }
    
    func transitionToNextStop(colorIdx: Int = 0) {
        guard colorIdx < gradientColors.count else {
            isComplete = true
            return
        }
        
        let animationDuration = 240 //seconds
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(Double(animationDuration))
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let newColors: [CGColor]
        if colorIdx+1 < gradientColors.count {
            newColors = Array(gradientColors[colorIdx...colorIdx+1])
        } else if let lastColor = gradientColors.last {
            newColors = [lastColor, lastColor]
        } else {
            return
        }
        
        let colorAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorAnimation.fromValue = gradientLayer.colors
        colorAnimation.toValue = newColors

        gradientLayer.colors = newColors
        
        gradientLayer.add(colorAnimation, forKey: #keyPath(CAGradientLayer.colors))
        
        CATransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(animationDuration)) { [weak self] in
            self?.transitionToNextStop(colorIdx: colorIdx+1)
        }
    }
}

extension TransitionView: SkyView {
    func animateOneFrame() {
        startTransitions()
    }
}
