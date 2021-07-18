//
//  NightView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/4/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// Our base night sky with stars.
//

final class NightView: NSView {
    private struct Constants {
        static let numberOfStars = 800
        static let minSize: CGFloat = 1
        static let maxSize: CGFloat = 4
        static let padding: CGFloat = 100
    }
    
    private let stars: [Star] = {
        var stars: [Star] = []
        for _ in 0..<Constants.numberOfStars {
            stars.append(Star())
        }
        return stars
    }()
    
    init() {
        super.init(frame: .zero)
        
        wantsLayer = true
        for s in stars {
            layer?.addSublayer(s)
        }
        
        layer?.backgroundColor = CGColor.nighttime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // place each star in a random spot with a random size
        for s in stars {
            var frame = NSRect.zero
            frame.size.width = CGFloat.random(in: Constants.minSize..<Constants.maxSize)
            frame.size.height = frame.size.width
            frame.origin.x = CGFloat.random(in: 0..<dirtyRect.size.width+Constants.padding)
            frame.origin.y = CGFloat.random(in: 0..<dirtyRect.size.height)
            s.frame = frame
        }
    }
}

extension NightView: AnimatableView {
    func animateOneFrame() {
        stars.forEach { (s) in
            var frame = s.frame

            // randomly increase/decrease its size a bit, to generate a twinkling effect
            if CGFloat.random(in: 0..<1) < 0.4 {
                let expand = Bool.random()
                let delta: CGFloat
                if expand {
                    delta = CGFloat.random(in: 0..<frame.size.width*1.2)
                } else {
                    delta = -1 * CGFloat.random(in: 0..<frame.size.width*0.2)
                }
                frame.size.width += delta
                frame.size.height = frame.size.width
                if frame.size.width <= Constants.minSize || frame.size.width >= Constants.maxSize {
                    frame.size = s.frame.size
                }
            }
            
            // shift it a tiny random amount to the left
            frame.origin.x -= s.starspeed
            if frame.origin.x + frame.size.width < 0 {
                s.isHidden = true
                frame.origin.x = bounds.size.width + Constants.padding
                frame.origin.y = CGFloat.random(in: 0..<bounds.size.height)
            } else if frame.origin.x <= bounds.size.width {
                s.isHidden = false
            }
            
            s.frame = frame
        }
    }
}
