//
//  CloudParticle.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

//
// A single cloud 'particle', that'll combine to form a cloud.
//

final class CloudParticle: CALayer {
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(opacity: CGFloat) {
        super.init()
        backgroundColor = NSColor(white: 250/255.0, alpha: opacity).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = frame.size.height / 2
    }
}
