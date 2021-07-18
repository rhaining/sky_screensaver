//
//  TransitionView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// The transition view represents a sunset or sunrise.
//

protocol TransitionViewDelegate: NSObject {
    func didComplete()
}

final class TransitionView: NSView {
    enum TransitionType {
        case sunrise, sunset
    }
    
    private struct Constants {
        static let transitionDuration: TimeInterval = 240
    }
    
    weak var delegate: TransitionViewDelegate?
    
    private let type: TransitionType
    private var hasStarted = false
    private var isComplete = false {
        didSet {
            if isComplete {
                delegate?.didComplete()
            }
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    private let gradientColors: [CGColor]

    init(type: TransitionType) {
        self.type = type
        
        switch type {
            case .sunrise:
                gradientLayer.colors = [CGColor.nighttime, CGColor.nighttime]
                //for sunrise, we want the colors to shift 180º
                gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
                gradientColors = CGColor.sunrise
                
            case .sunset:
                gradientLayer.colors = [CGColor.daytime, CGColor.daytime]
                gradientColors = CGColor.sunset
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
    
    private func startTransitions() {
        guard !hasStarted else { return }
        
        hasStarted = true
        
        transitionToNextStop()
    }
    
    //every 4 minutes, let's shift to the next pair of colors for our gradient.
    private func transitionToNextStop(colorIdx: Int = 0) {
        guard colorIdx < gradientColors.count else {
            isComplete = true
            return
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(Constants.transitionDuration)
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(Constants.transitionDuration))) { [weak self] in
            self?.transitionToNextStop(colorIdx: colorIdx+1)
        }
    }
}

extension TransitionView: AnimatableView {
    func animateOneFrame() {
        startTransitions()
    }
}
