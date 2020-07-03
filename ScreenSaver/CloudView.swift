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
        static let numberOfClouds = 12
//        static let minSize: CGFloat = 1
//        static let maxSize: CGFloat = 4
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
        for c in clouds {
            layer?.addSublayer(c)
        }
        
        layer?.backgroundColor = NSColor(red: 164/255.0, green: 221/255.0, blue: 250/255.0, alpha: 1).cgColor
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
    
    func random() {
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

final class Cloud: CALayer {
    let cloudspeed: CGFloat = CGFloat.random(in: 0.05..<0.7)
    let particles: [CloudParticle]
    
    override init(layer: Any) {
        if let cloudLayer = layer as? Cloud {
            particles = cloudLayer.particles
        } else {
            // shrug
            particles = []
        }
        super.init(layer: layer)
    }
    static func calculateAlpha(i: Int, j: Int, width: CGFloat, height: CGFloat) -> CGFloat {
        var alpha: CGFloat = 0.0
        let iF = CGFloat(i)
        let jF = CGFloat(j)
        
        if iF < width / 2.0 {
            alpha += iF
        } else {
            alpha += width - iF
        }
        
        if jF < height / 2.0 {
            alpha *= jF
        } else {
            alpha *= height - jF
        }
        
        alpha /= CGFloat(width * height / 4.0) * 5.0
        return alpha
    }
    init(frame: CGRect) {
        var particles: [CloudParticle] = []
        
        for i in 0..<Int(frame.width) {
            if i % 4 != 0 { continue }
            for j in 0..<Int(frame.height) {
                if j % 4 != 0 { continue }
                let alpha = Cloud.calculateAlpha(i: i, j: j, width: frame.width, height: frame.height)
                let p = CloudParticle(alpha: alpha)
                p.frame = CGRect(x: CGFloat(i),
                                 y: CGFloat(j),
                                 width: 10,//CGFloat.random(in: 15..<16),
                                 height: 10)//CGFloat.random(in: 15..<10))
                particles.append(p)
            }
        }
        self.particles = particles
        super.init()
        self.frame = frame
        backgroundColor = NSColor.clear.cgColor
        
        for p in particles {
            addSublayer(p)
        }
        
        shouldRasterize = true
        drawsAsynchronously = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
}

final class CloudParticle: CALayer {
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(alpha: CGFloat) {
        super.init()
        backgroundColor = NSColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: alpha).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = frame.size.height / 2
    }

}
