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
    
    func buildFormFields(withOutputCurrencies currencies: [Currency])
    
    func updateOutput(forCurrency currency: Currency, withRate rate: Double)
    
    func displayError(withText text: String)
    
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
            
            static let comparisonChartSectionTitleComment = "COMPARISON CHART"
        }
        
        struct Tag {
            static let inputFieldTag = "inputField"
            
            static let genericOutputFieldTagSuffix = "OutputField"
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
    
    var chartSection: Section!
    
    var outputCurrencyTextRows = [Currency: TextRow]()
    
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
    
    func buildFormFields(withOutputCurrencies currencies: [Currency]) {
        buildInputFormFields()
        buildOutputFormFields(withOutputCurrencies: currencies)
    }
    
    func updateOutput(forCurrency currency: Currency, withRate rate: Double) {
        let outputRow = outputCurrencyTextRows[currency]
        outputRow?.value = String(format: "%.5f \(currency.raw)", rate)
        outputSection.reload()
    }
    
    func displayError(withText text: String) {
        let vc = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(vc, animated: true, completion: nil)
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
    
    private func buildOutputFormFields(withOutputCurrencies currencies: [Currency]) {
        let outputSectionName = NSLocalizedString("resultsPerCurrencySectionTitle", comment: K.String.resultsPerCurrencySectionTitleComment)
        let secondsOutputCaption = NSLocalizedString("resultsForSecondsCaption", comment: K.String.resultsForSecondsCaption)
        
        let loadingCopy = NSLocalizedString("loadingCopy", comment: K.String.loadingCopyComment)
        
        outputSection = Section(outputSectionName)
        
        for (index, outputCurrency) in currencies.enumerated() {
            let textRow = TextRow("\(outputCurrency.raw.lowercased())\(K.Tag.genericOutputFieldTagSuffix)") {
                $0.title = index > 0 ? secondsOutputCaption : " "
                
                if let currentValue = self.presenter.currentValues[outputCurrency], currentValue != nil {
                    $0.value = String(format: "%.5f \(outputCurrency.raw)", currentValue!)
                } else {
                    $0.value = loadingCopy
                }
                
            }.cellSetup(outputCellSetup)
            
            outputCurrencyTextRows[outputCurrency] = textRow
            
            outputSection <<< textRow
        }
        
        outputSection.hidden = Condition.function([K.Tag.inputFieldTag], {
            guard let inputTextRow = $0.rowBy(tag: K.Tag.inputFieldTag) as? TextRow, let value = inputTextRow.value, let intValue = Int(value) else {
                return true
            }
            
            return intValue <= 0
        })
        
        form +++ outputSection
    }
    
    private func buildChartFormField() {
        let chartSectionName = NSLocalizedString("comparisonChartSectionTitle", comment: K.String.comparisonChartSectionTitleComment)
        
        //let viewRow = 
        
        chartSection = Section(chartSectionName)
    }

}

