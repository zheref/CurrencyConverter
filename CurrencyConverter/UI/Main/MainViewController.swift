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
            
            static let loadingCopyComment = "Loading..."
        }
        
        struct Tag {
            static let inputFieldTag = "inputField"
            
            static let poundsOutputFieldTag = "poundsOutputField"
            static let euroOutputFieldTag = "euroOutputField"
            static let yenOutputFieldTag = "yenOutputField"
            static let reaisOutputFieldTag = "reaisOutputField"
        }
        
    }
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Outlets
    
    var inputSection: Section!
    var inputTextRow: TextRow!
    
    var outputSection: Section!
    
    var poundsOutputTextRow: TextRow!
    var euroOutputTextRow: TextRow!
    var yenOutputTextRow: TextRow!
    var reaisOutputTextRow: TextRow!
    
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
        buildInputFormFields()
        buildOutputFormFields()
    }
    
    // MARK: Private Operations
    
    private func buildInputFormFields() {
        let inputSectionName = NSLocalizedString("numberOfDollarBillsSectionTitle", comment: K.String.numberOfDollarBillsSectionTitleComment)
        let inputFieldCaption = NSLocalizedString("numberOfOnesBillsFieldCaption", comment: K.String.numberOfOnesBillsFieldCaptionComment)
        
        inputTextRow = TextRow(K.Tag.inputFieldTag) {
            $0.title = inputFieldCaption
            $0.value = K.String.numberOfOnesBillsFieldDefaultValue
        }.cellSetup({ cell, row in
            cell.textField.keyboardType = .numberPad
        }).onChange({ [weak self] (row) in
            guard let value = row.value, let intValue = Int(value) else {
                // New value is not valid to process
                return
            }
            
            self?.presenter.numberOfDollarsDidChange(toValue: intValue)
        })
        
        inputSection = Section(inputSectionName)
            <<< inputTextRow
        
        form +++ inputSection
    }
    
    private func outputCellSetup(cell: TextCell, row: TextRow) {
        cell.textField.isEnabled = false
        cell.textField.isUserInteractionEnabled = false
    }
    
    private func buildOutputFormFields() {
        let outputSectionName = NSLocalizedString("resultsPerCurrencySectionTitle", comment: K.String.resultsPerCurrencySectionTitleComment)
        let secondsOutputCaption = NSLocalizedString("resultsForSecondsCaption", comment: K.String.resultsForSecondsCaption)
        
        let loadingCopy = NSLocalizedString("loadingCopy", comment: K.String.loadingCopyComment)
        
        poundsOutputTextRow = TextRow(K.Tag.poundsOutputFieldTag) {
            $0.title = " "
            $0.value = loadingCopy
        }.cellSetup(outputCellSetup)
        
        euroOutputTextRow = TextRow(K.Tag.euroOutputFieldTag) {
            $0.title = secondsOutputCaption
            $0.value = loadingCopy
        }.cellSetup(outputCellSetup)
        
        yenOutputTextRow = TextRow(K.Tag.yenOutputFieldTag) {
            $0.title = secondsOutputCaption
            $0.value = loadingCopy
        }.cellSetup(outputCellSetup)
        
        reaisOutputTextRow = TextRow(K.Tag.reaisOutputFieldTag) {
            $0.title = secondsOutputCaption
            $0.value = loadingCopy
        }.cellSetup(outputCellSetup)
        
        outputSection = Section(outputSectionName)
            <<< poundsOutputTextRow
            <<< euroOutputTextRow
            <<< yenOutputTextRow
            <<< reaisOutputTextRow
        
        outputSection.hidden = Condition.function([K.Tag.inputFieldTag], {
            guard let inputTextRow = $0.rowBy(tag: K.Tag.inputFieldTag) as? TextRow, let value = inputTextRow.value, let intValue = Int(value) else {
                return true
            }
            
            return intValue <= 0
        })
        
        form +++ outputSection
    }

}

