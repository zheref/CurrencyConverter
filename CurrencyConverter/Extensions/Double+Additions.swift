//
//  Double+Additions.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation
import SwifterSwift

extension Double {
    
    func rounded(byDecimals decimals: Int) -> Double {
        let module: Double = 10 * Double(decimals)
        return (self * module).floor / module
    }
    
}
