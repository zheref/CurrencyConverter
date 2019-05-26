//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import UIKit
import Eureka

protocol MainViewControllerProtocol : class {
    
    func buildFormFields()
    
}

class MainViewController : FormViewController, MainViewControllerProtocol {
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Stored Properties
    
    let presenter: MainPresenterProtocol = MainPresenter(conversionFetcher: ConversionFetcher.standard)
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attach(view: self)
        presenter.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        presenter.viewIsBeingDisplayed()
    }
    
    // MARK: - INSTANCE OPERATIONS
    
    // MARK: Exposed Operations -> Protocol Exposed
    
    func buildFormFields() {
        form +++ Section("NUMBER OF DOLLAR BILLS")
            <<< TextRow() { row in
                row.title = "#1$ bills"
                row.value = "0"
            }
    }

}

