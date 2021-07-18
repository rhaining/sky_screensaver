//
//  Solar.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 6/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import CoreLocation

//
// adapted from the sunrise equation
//    https://en.wikipedia.org/wiki/Sunrise_equation
//

final class Solar {
    var sunrise: Date?
    var sunset: Date?
    
    let date: Date
    let coordinate: CLLocationCoordinate2D
    
    init?(for date: Date, coordinate: CLLocationCoordinate2D) {
        self.date = date
        self.coordinate = coordinate
        calculate()
    }
    
    func calculate() {        
        let lw = coordinate.longitude
        let Φ = coordinate.latitude
        
        //  n is the number of days since Jan 1st, 2000 12:00.
        let n = Julian.daysSinceY2KNoon(for: date)
        
        //Mean solar noon
        let jStar = n - (lw / 360)
        
        //M is the solar mean anomaly used in the next three equations.
        let M = (357.5291 + 0.98560028 * jStar).truncatingRemainder(dividingBy: 360.0)
        
        //C is the Equation of the center value needed to calculate lambda (see next equation).
        let C1 = 1.9148 * Trigonometry.sinDegrees(M)
        let C2 = 0.0200 * Trigonometry.sinDegrees(2*M)
        let C3 = 0.0003 * Trigonometry.sinDegrees(3*M)
        let C = C1 + C2 + C3
        
        //    λ is the ecliptic longitude.
        let λ = (M + C + 180 + 102.9372).truncatingRemainder(dividingBy: 360.0)
        
        // Jtransit is the Julian date for the local true solar transit (or solar noon).
        let jTransit = 2451545.0
                        + jStar
                        + (0.0053 * Trigonometry.sinDegrees(M))
                        - (0.0069 * Trigonometry.sinDegrees(2 * λ))
        
        //declination of sun
        let δ = Trigonometry.asinDegrees( Trigonometry.sinDegrees(λ) * Trigonometry.sinDegrees(23.44) )
        
        //hour angle
        // -0.83
        let coswoNumerator = Trigonometry.sinDegrees(-0.83)
                            - (Trigonometry.sinDegrees(Φ) * Trigonometry.sinDegrees(δ))
        let coswoDenominator = Trigonometry.cosDegrees(Φ) * Trigonometry.cosDegrees(δ)
        let wo = Trigonometry.acosDegrees( coswoNumerator / coswoDenominator )
        
        //sunrise
        let jRise = jTransit - (wo / 360.0)
        
        //sunset
        let jSet = jTransit + (wo / 360.0)
        
        self.sunrise = Julian.dateForJulianDays(julianDays: jRise)
        self.sunset = Julian.dateForJulianDays(julianDays: jSet)
    }
}

extension Solar {
    
    // Whether the location specified by the `latitude` and `longitude` is in daytime on `date`
    public var isDaytime: Bool {
        guard
            let sunrise = sunrise,
            let sunset = sunset
            else {
                return false
        }
        
        let beginningOfDay = sunrise.timeIntervalSince1970
        let endOfDay = sunset.timeIntervalSince1970
        let currentTime = self.date.timeIntervalSince1970
        
        let isSunriseOrLater = currentTime >= beginningOfDay
        let isBeforeSunset = currentTime < endOfDay
        
        return isSunriseOrLater && isBeforeSunset
    }
    
    // Whether the location specified by the `latitude` and `longitude` is in nighttime on `date`
    public var isNighttime: Bool {
        return !isDaytime
    }
}


