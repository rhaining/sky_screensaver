//
//  TransitionForecaster.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 6/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import CoreLocation

protocol TransitionForecasterDelegate {
    func shouldUpdateToCurrentSkyMode(_ skyMode: SkyMode)
    func shouldPlanForNextTransition(_ skyMode: SkyMode, at date: Date)
    func didFail(error: Error?)
}

final class TransitionForecaster {
    
    var delegate: TransitionForecasterDelegate?
    
    func start() {
        getLocation()
    }
    
    func getLocation() {
        LocationHelper.shared.getLocation { [weak self] (coordinate, error) in
            if let coordinate = coordinate {
                self?.getSolar(coordinate: coordinate)
            } else {
                self?.delegate?.didFail(error: error)
            }
        }
    }
    
    func getSolar(for date: Date = Date(), coordinate: CLLocationCoordinate2D) {
        guard let solar = Solar(for: date, coordinate: coordinate),
            let sunriseDate = solar.sunrise,
            let sunsetDate = solar.sunset
            else {
                delegate?.didFail(error: nil)
                return
        }
        
        NSLog("today's sunrise: \(sunriseDate)")
        NSLog("today's sunset: \(sunsetDate)")

        var currentSkyMode: SkyMode = solar.isDaytime ? .day : .night

        if sunriseDate.isInTheFuture(from: date) {
            delegate?.shouldPlanForNextTransition(SkyMode.sunrise, at: sunriseDate)
        } else if sunriseDate.wasRecent(from: date) {
            currentSkyMode = .sunrise
        }

        if sunriseDate.isPast(from: date) && !sunriseDate.wasRecent(from: date) {
            if sunsetDate.isInTheFuture(from: date) {
                delegate?.shouldPlanForNextTransition(SkyMode.sunset, at: sunsetDate)
            } else if sunsetDate.wasRecent(from: date) {
                currentSkyMode = .sunset
            }
        }
        
        if sunriseDate.isPast(from: date) && sunsetDate.isPast(from: date) && !sunsetDate.wasRecent(from: date),
            let justAfterMidnight = date.justAfterMidnight,
            let tomororwsSolar = Solar(for: justAfterMidnight, coordinate: coordinate),
            let tomorrowsSunriseDate = tomororwsSolar.sunrise,
            tomorrowsSunriseDate.isInTheFuture(from: date) {
                
                //tomorrow sunrise is next transition time.
                delegate?.shouldPlanForNextTransition(SkyMode.sunrise, at: tomorrowsSunriseDate)
        }
        
        delegate?.shouldUpdateToCurrentSkyMode(currentSkyMode)
    }
}


