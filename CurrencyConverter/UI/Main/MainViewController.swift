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
    
    // MARK: - NESTED TYPES
    
    struct K {
        
        struct String {
            static let numberOfDollarBillsSectionTitleComment = "NUMBER OF DOLLAR BILLS"
            static let numberOfOnesBillsFieldCaptionComment = "#1$ bills"
            static let numberOfOnesBillsFieldDefaultValue = "0"
            
            static let resultsPerCurrencySectionTitleComment = "YOU HAVE..."
            static let resultsForSecondsCaption = "or..."
        }
        
        struct Tag {
            static let inputFieldTag = "inputField"
        }
        
    }
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Outlets
    
    var inputSection: Section!
    var inputTextRow: TextRow!
    
    var outputSection: Section!
    
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
        let inputSectionName = NSLocalizedString("numberOfDollarBillsSectionTitle", comment: K.String.numberOfDollarBillsSectionTitleComment)
        let inputFieldCaption = NSLocalizedString("numberOfOnesBillsFieldCaption", comment: K.String.numberOfOnesBillsFieldCaptionComment)
        
        let outputSectionName = NSLocalizedString("resultsPerCurrencySectionTitle", comment: K.String.resultsPerCurrencySectionTitleComment)
        let secondsOutputCaption = NSLocalizedString("resultsForSecondsCaption", comment: K.String.resultsForSecondsCaption)
        
        inputTextRow = TextRow(K.Tag.inputFieldTag) { row in
            row.title = inputFieldCaption
            row.value = K.String.numberOfOnesBillsFieldDefaultValue
        }
        
        inputSection = Section(inputSectionName)
            <<< inputTextRow
        
        outputSection = Section(outputSectionName)
        outputSection.hidden = Condition.function([K.Tag.inputFieldTag], { form in
            guard let inputTextRow = form.rowBy(tag: K.Tag.inputFieldTag) as? TextRow, let value = inputTextRow.value, let intValue = Int(value) else {
                return true
            }
            
            return intValue <= 0
        })
        
        form +++ inputSection
        form +++ outputSection
    }

}

