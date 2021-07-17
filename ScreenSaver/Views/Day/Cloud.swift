//
//  Cloud.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

// `Cloud` will generate a cloud layer we can size & shift around

final class Cloud: CALayer {
    private struct Constants {
        static let cloudspeedRange: Range<CGFloat> = 0.05..<0.7
        static let padding = 4
        static let size: CGFloat = 9.0
    }
    
    let cloudspeed: CGFloat = CGFloat.random(in: Constants.cloudspeedRange)
    private let particles: [CloudParticle]
    
    override init(layer: Any) {
        if let cloudLayer = layer as? Cloud {
            particles = cloudLayer.particles
        } else {
            // shrug
            particles = []
        }
        super.init(layer: layer)
    }
    
    //the closer we are to the middle of teh cloud, the more opaque & less transparent we want to be
    private static func calculateParticleOpacity(particleOrigin: CGPoint, cloudSize: CGSize) -> CGFloat {
        var alpha: CGFloat = 0.0
                
        if particleOrigin.x < cloudSize.width / 2.0 {
            alpha += particleOrigin.x
        } else {
            alpha += cloudSize.width - particleOrigin.x
        }
        
        if particleOrigin.y < cloudSize.height / 2.0 {
            alpha *= particleOrigin.y
        } else {
            alpha *= cloudSize.height - particleOrigin.y
        }
        
        alpha /= CGFloat(cloudSize.width * cloudSize.height / 4.0) * 5.0
        
        return alpha
    }
    
    //create a cloud & generate its particles
    init(frame: CGRect) {
        var particles: [CloudParticle] = []
        
        for i in 0..<Int(frame.width) / Constants.padding {
            let x = i * Constants.padding
            for j in 0..<Int(frame.height) / Constants.padding {
                let y = j * Constants.padding
                let opacity = Cloud.calculateParticleOpacity(particleOrigin: CGPoint(x: x, y: y), cloudSize: frame.size)
                let p = CloudParticle(opacity: opacity)
                p.frame = CGRect(x: CGFloat(x),
                                 y: CGFloat(y),
                                 width: Constants.size,
                                 height: Constants.size)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
