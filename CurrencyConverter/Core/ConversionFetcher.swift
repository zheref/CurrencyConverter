//
//  ConversionFetcher.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

protocol ConversionFetcherProtocol {
    
}

class ConversionFetcher : ConversionFetcherProtocol {
    
    // MARK: - CLASS MEMBERS
    
    static let standard: ConversionFetcherProtocol = ConversionFetcher()
    
    // MARK: - INITIALIZERS
    
    private init() {}
    
}
