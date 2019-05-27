//
//  MainPresenter.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation


protocol MainPresenterProtocol : GenericPresenterProtocol {
    
    var currentValues: [Currency: Double?] { get set }
    
    func attach(view: MainViewControllerProtocol)
    func dettachView()
    
    func numberOfDollarsDidChange(toValue value: Int)
    
}

class MainPresenter : MainPresenterProtocol {
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Stored Properties
    
    private let conversionFetcher: ConversionFetcherProtocol
    weak private var view: MainViewControllerProtocol?
    
    let outputCurrencies: [Currency] = [.GBP, .EUR, .JPY, .BRL]
    
    var currentValues: [Currency: Double?] = [
        .GBP: nil,
        .EUR: nil,
        .JPY: nil,
        .BRL: nil
    ]
    
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
        
        let _ = conversionFetcher.fetchLatestRates { [weak self] (response, error) in
            if let error = error {
                self?.view?.displayError(withText: error.localizedDescription)
            }
            
            guard let strongSelf = self, let response = response else {
                return
            }
            
            for outputCurrency in strongSelf.outputCurrencies {
                let rate = response.rates[outputCurrency]
                
                let actualResult = Double(value) * rate
                
                self?.currentValues[outputCurrency] = actualResult
                
                DispatchQueue.main.async {
                    strongSelf.view?.updateOutput(forCurrency: outputCurrency, withRate: actualResult)
                }
            }
        }
    }
    
    // MARK: Generalized Exposed Presenter Operations
    
    func viewIsReady() {
        view?.buildFormFields(withOutputCurrencies: outputCurrencies)
    }
    
    func viewIsBeingDisplayed() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}
