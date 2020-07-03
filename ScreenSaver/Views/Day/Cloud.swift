//
//  Cloud.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

final class Cloud: CALayer {
    struct Constants {
        static let cloudspeedRange: Range<CGFloat> = 0.05..<0.7
        static let padding = 4
        static let size: CGFloat = 9.0
    }
    
    let cloudspeed: CGFloat = CGFloat.random(in: Constants.cloudspeedRange)
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
    static func calculateAlpha(x: Int, y: Int, width: CGFloat, height: CGFloat) -> CGFloat {
        var alpha: CGFloat = 0.0
        let xF = CGFloat(x)
        let yF = CGFloat(y)
        
        if xF < width / 2.0 {
            alpha += xF
        } else {
            alpha += width - xF
        }
        
        if yF < height / 2.0 {
            alpha *= yF
        } else {
            alpha *= height - yF
        }
        
        alpha /= CGFloat(width * height / 4.0) * 5.0
        return alpha
    }
    init(frame: CGRect) {
        var particles: [CloudParticle] = []
        
        for i in 0..<Int(frame.width) / Constants.padding {
            let x = i * Constants.padding
            for j in 0..<Int(frame.height) / Constants.padding {
                let y = j * Constants.padding
                let alpha = Cloud.calculateAlpha(x: x, y: y, width: frame.width, height: frame.height)
                let p = CloudParticle(alpha: alpha)
                p.frame = CGRect(x: CGFloat(x),
                                 y: CGFloat(y),
                                 width: Constants.size,//CGFloat.random(in: 15..<16),
                                height: Constants.size)//CGFloat.random(in: 15..<10))
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
        
//        shouldRasterize = true
//        drawsAsynchronously = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
}
