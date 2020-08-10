//
//  DayView.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/6/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

final class DayView: NSView {
    struct Constants {
        static let numberOfClouds = 25
        static let padding: CGFloat = 100
    }

    let clouds: [Cloud] = {
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
        layer?.backgroundColor = ColorHelper.daytime

        for c in clouds {
            layer?.addSublayer(c)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for c in clouds {
            var frame = c.frame
            frame.origin.x = CGFloat.random(in: -Constants.padding..<dirtyRect.size.width+Constants.padding)
            frame.origin.y = CGFloat.random(in: -Constants.padding..<dirtyRect.size.height)
            c.frame = frame
        }
    }
}

extension DayView: SkyView {
    func animateOneFrame() {
        clouds.forEach { (c) in
            var frame = c.frame
            frame.origin.x -= c.cloudspeed
            
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

