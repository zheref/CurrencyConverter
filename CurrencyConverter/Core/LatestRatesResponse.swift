//
//  LatestRatesResponse.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

struct Rates : Codable {
    var GBP: Double
    var EUR: Double
    var JPY: Double
    var BRL: Double
    
    subscript(key: Currency) -> Double {
        switch(key) {
        case .GBP:
            return GBP
        case .EUR:
            return EUR
        case .JPY:
            return JPY
        case .BRL:
            return BRL
        case .USD:
            return 1
        default:
            return 0
        }
    }
}

struct LatestRatesResponse : Codable {
    
    var success: Bool
    var timestamp: TimeInterval
    var base: Currency
    var date: String
    var rates: Rates
    
}
