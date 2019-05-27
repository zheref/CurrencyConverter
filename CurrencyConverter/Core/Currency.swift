//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

enum Currency : String, Codable {
    case USD
    case GBP
    case EUR
    case JPY
    case BRL
    
    var raw: String {
        switch self {
        case .USD:
            return "USD"
        case .GBP:
            return "GBP"
        case .EUR:
            return "EUR"
        case .JPY:
            return "JPY"
        case .BRL:
            return "BRL"
        }
    }
}
