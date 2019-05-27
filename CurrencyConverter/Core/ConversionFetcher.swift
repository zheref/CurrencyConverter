//
//  ConversionFetcher.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation
import Alamofire

typealias LatestRatesHandler = (LatestRatesResponse?, Error?) -> Void

protocol ConversionFetcherProtocol {
    
}

class ConversionFetcher : ConversionFetcherProtocol {
    
    // MARK: - NESTED TYPES
    
    struct K {
        struct Url {
            static let base = URL(string: "http://data.fixer.io/api")
        }
        
        struct Key {
            static let access = "f0b18df4f876016fe3aaecf789225f24"
        }
    }
    
    // MARK: - CLASS MEMBERS
    
    static let standard: ConversionFetcherProtocol = ConversionFetcher()
    
    // MARK: - INITIALIZERS
    
    private init() {}
    
    // MARK: - INSTANCE OPERATIONS
    
    // MARK: Exposed Operations
    
    func fetchLatestRates(completion: LatestRatesHandler) {
        //Alamofire.request("\(K.Url.base)/latest/\()")
        
    }
    
}
