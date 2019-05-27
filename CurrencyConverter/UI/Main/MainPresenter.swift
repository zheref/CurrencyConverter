//
//  MainPresenter.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation


protocol MainPresenterProtocol : GenericPresenterProtocol {
    
    func attach(view: MainViewControllerProtocol)
    func dettachView()
    
    func numberOfDollarsDidChange(toValue value: Int)
    
}

class MainPresenter : MainPresenterProtocol {
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Stored Properties
    
    private let conversionFetcher: ConversionFetcherProtocol
    weak private var view: MainViewControllerProtocol?
    
    // MARK: - INITIALIZERS
    
    init(conversionFetcher: ConversionFetcherProtocol) {
        self.conversionFetcher = conversionFetcher
    }
    
    // MARK: - INSTANCE OPERATIONS
    
    // MARK: Exposed Operations -> Protocol Exposed
    
    func attach(view: MainViewControllerProtocol) {
        self.view = view
    }
    
    func dettachView() {
        self.view = nil
    }
    
    func numberOfDollarsDidChange(toValue value: Int) {
        guard value > 0 else {
            // Do nothing because stack is fewer than 0
            return
        }
        
        
    }
    
    // MARK: Generalized Exposed Presenter Operations
    
    func viewIsReady() {
        view?.buildFormFields()
    }
    
    func viewIsBeingDisplayed() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}
