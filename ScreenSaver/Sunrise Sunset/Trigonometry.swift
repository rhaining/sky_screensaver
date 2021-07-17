//
//  Trigonometry.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 7/17/21.
//  Copyright © 2021 Robert Tolar Haining. All rights reserved.
//

import Foundation

struct Trigonometry {
    static func sinDegrees(_ degrees: Double) -> Double {
        return sin(degrees.degreesToRadians)
    }
    
    static func asinDegrees(_ degrees: Double) -> Double {
        return asin(degrees).radiansToDegrees
    }
    
    static func cosDegrees(_ degrees: Double) -> Double {
        return cos(degrees.degreesToRadians)
    }
    
    static func acosDegrees(_ degrees: Double) -> Double {
        return acos(degrees).radiansToDegrees
    }
}

private extension Double {
    var degreesToRadians: Double {
        return Double(self) * (Double.pi / 180.0)
    }
    var radiansToDegrees: Double {
        return (Double(self) * 180.0) / Double.pi
    }
}
