//
//  ColorHelper.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/9/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import AppKit

struct ColorHelper {
    static let daytime = NSColor(red: 164/255.0, green: 221/255.0, blue: 250/255.0, alpha: 1).cgColor
    static let nighttime = NSColor(red: 19/255.0, green: 24/255.0, blue: 98/255.0, alpha: 1).cgColor
    
    static let sunset = [
        ColorHelper.daytime,
        NSColor(red: 255/255.0, green: 229/255.0, blue: 119/255.0, alpha: 1).cgColor,
        NSColor(red: 254/255.0, green: 192/255.0, blue: 81/255.0, alpha: 1).cgColor,
        NSColor(red: 255/255.0, green: 137/255.0, blue: 103/255.0, alpha: 1).cgColor,
        NSColor(red: 253/255.0, green: 96/255.0, blue: 81/255.0, alpha: 1).cgColor,
        NSColor(red: 103/255.0, green: 32/255.0, blue: 119/255.0, alpha: 1).cgColor,
        ColorHelper.nighttime
    ]
    
    static let sunrise = [
        ColorHelper.nighttime,
        NSColor(red: 197/255.0, green: 172/255.0, blue: 167/255.0, alpha: 1).cgColor,
        NSColor(red: 250/255.0, green: 179/255.0, blue: 149/255.0, alpha: 1).cgColor,
        NSColor(red: 123/255.0, green: 149/255.0, blue: 182/255.0, alpha: 1).cgColor,
        ColorHelper.daytime
    ]
}
