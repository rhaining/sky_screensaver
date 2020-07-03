//
//  SkyMode.swift
//  Stars
//
//  Created by Robert Tolar Haining on 5/10/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import AppKit

enum SkyMode: CaseIterable {
    case sunrise, day, sunset, night
        
    func next() -> SkyMode {
        if let currentIndex = SkyMode.allCases.firstIndex(of: self),
            currentIndex+1 < SkyMode.allCases.count {
            return SkyMode.allCases[currentIndex+1]
        } else {
            return SkyMode.allCases[0]
        }
    }
}
