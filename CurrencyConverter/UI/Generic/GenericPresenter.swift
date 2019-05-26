//
//  GenericPresenter.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

protocol GenericPresenterProtocol : class {
    
    func viewIsReady()
    
    func viewIsBeingDisplayed()
    
    func viewWillDisappear()
    
}
