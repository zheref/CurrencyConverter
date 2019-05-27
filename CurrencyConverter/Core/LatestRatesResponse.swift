//
//  LatestRatesResponse.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

struct LatestRatesResponse : Codable {
    
    var success: Bool
    var timestamp: TimeInterval
    var base: Currency
    var date: String
    var rates: [Currency: Double]
    
}
