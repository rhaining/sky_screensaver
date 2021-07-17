//
//  Animatable.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 7/17/21.
//  Copyright © 2021 Robert Tolar Haining. All rights reserved.
//

import Foundation
import AppKit

protocol AnimatableView: NSView {
    func animateOneFrame()
}
