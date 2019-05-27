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
    
    case UNK
    
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
        case .UNK:
            return ""
        }
    }
    
    var asInteger: Int {
        switch self {
        case .USD:
            return -1
        case .GBP:
            return 1
        case .EUR:
            return 2
        case .JPY:
            return 3
        case .BRL:
            return 4
        case .UNK:
            return 0
        }
    }
    
    static func from(int: Int) -> Currency {
        switch int {
        case 0:
            return .UNK
        case 1:
            return .GBP
        case 2:
            return .EUR
        case 3:
            return .JPY
        case 4:
            return .BRL
        default:
            return .UNK
        }
    }
}
