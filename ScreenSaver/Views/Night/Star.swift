//
//  Star.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

final class Star: CALayer {
    let starspeed: CGFloat = CGFloat.random(in: 0.1..<0.3)
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    override init() {
        super.init()
        backgroundColor = NSColor(red: 255/255.0, green: 248/255.0, blue: 231/255.0, alpha: 0.95).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = frame.size.height / 2
    }
    
}
