//
//  DayView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/6/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// Our base day view with clouds.
//

final class DayView: NSView {
    private struct Constants {
        static let numberOfClouds = 25
        static let padding: CGFloat = 100
    }

    // let's give our clouds a random size
    // + don't worry about placement quite yet
    private let clouds: [Cloud] = {
        var clouds: [Cloud] = []
        for _ in 0..<Constants.numberOfClouds {
            let width = round(CGFloat.random(in: 150..<350))
            let height = round(width * CGFloat.random(in: 0.5..<0.8))
            clouds.append(Cloud(frame: CGRect(x: 0, y: 0, width: width, height: height)))
        }
        return clouds
    }()

    init() {
        super.init(frame: .zero)
        
        wantsLayer = true
        layer?.backgroundColor = CGColor.daytime

        for c in clouds {
            layer?.addSublayer(c)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // starts our clouds at random points on the screen
        for c in clouds {
            var frame = c.frame
            frame.origin.x = CGFloat.random(in: -Constants.padding..<dirtyRect.size.width+Constants.padding)
            frame.origin.y = CGFloat.random(in: -Constants.padding..<dirtyRect.size.height)
            c.frame = frame
        }
    }
}

extension DayView: AnimatableView {
    func animateOneFrame() {
        clouds.forEach { (c) in
            var frame = c.frame
            //cloud floats to the left
            frame.origin.x -= c.cloudspeed
            
            // if the cloud's offscreen, let's reset its 'x' to the right & randomize the 'y'
            if frame.maxX < 0 {
                c.isHidden = true
                frame.origin.x = bounds.size.width + Constants.padding
                frame.origin.y = CGFloat.random(in: 0..<bounds.size.height)
            } else if frame.minX <= bounds.size.width {
                c.isHidden = false
            }
            
            c.frame = frame
        }
    }
}

