//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import UIKit
import Eureka
import ViewRow
import SnapKit

protocol MainViewControllerProtocol : class {
    
    func buildInputFormFields()
    
    func buildOutputFormFields(withExchangeSet exchangeSet: ExchangeSet)
    
    func buildChartFormField(withExchangeSet exchangeSet: ExchangeSet)
    
    func updateOutput(forCurrency currency: Currency, withRate rate: Double)
    
    func displayError(withText text: String)
    
    func updateChart(withExchangeSet exchangeSet: ExchangeSet)
    
}

class MainViewController : FormViewController, MainViewControllerProtocol {
    
    // MARK: - NESTED TYPES
    
    struct K {
        
        struct String {
            static let numberOfDollarBillsSectionTitleComment = "NUMBER OF DOLLAR BILLS"
            static let numberOfOnesBillsFieldCaptionComment = "# of 1$"
            static let numberOfOnesBillsFieldDefaultValue = ""
            
            static let resultsPerCurrencySectionTitleComment = "YOU HAVE..."
            static let resultsForSecondsCaption = "or..."
            
            static let loadingCopyComment = "Loading..."
            
            static let comparisonChartSectionTitleComment = "COMPARISON CHART"
        }
        
        struct Tag {
            static let inputFieldTag = "inputField"
            static let genericOutputFieldTagSuffix = "OutputField"
        }
        
        struct Measure {
            static let polesMargin: CGFloat = 5.0
            static let chartHeight: CGFloat = 200
        }
        
        struct Storyboard {
            static let main = "Main"
        }
        
        struct ViewController {
            static let chartVC = "chartVC"
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
    
    var chartVC: ChartViewController?
    
    // MARK: Stored Properties
    
    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: K.Storyboard.main, bundle: nil)
    }
    
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
    
    func buildInputFormFields() {
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
            }).onCellSelection({ (cell, row) in
                guard let value = row.value, let intValue = Int(value) else {
                    // New value is not valid to process
                    return
                }
                
                if intValue <= 0 {
                    row.value = ""
                }
            })
        
        inputSection = Section(inputSectionName)
            <<< inputTextRow
        
        form +++ inputSection
    }
    
    func buildOutputFormFields(withExchangeSet exchangeSet: ExchangeSet) {
        // Localized copies
        let outputSectionName = NSLocalizedString("resultsPerCurrencySectionTitle", comment: K.String.resultsPerCurrencySectionTitleComment)
        let secondsOutputCaption = NSLocalizedString("resultsForSecondsCaption", comment: K.String.resultsForSecondsCaption)
        let loadingCopy = NSLocalizedString("loadingCopy", comment: K.String.loadingCopyComment)
        
        outputSection = Section(outputSectionName)
        
        var isFirst = true
        
        for (currency, rate) in exchangeSet {
            let textRowTag = "\(currency.raw.lowercased())\(K.Tag.genericOutputFieldTagSuffix)"
            
            let textRow = TextRow(textRowTag) {
                $0.title = !isFirst ? secondsOutputCaption : " "
                
                if rate != nil {
                    $0.value = String(format: "%.2f \(currency.raw)", rate!)
                } else {
                    $0.value = loadingCopy
                }
                
            }.cellSetup(outputCellSetup)
            
            outputCurrencyTextRows[currency] = textRow
            outputSection <<< textRow
            isFirst = false
        }
        
        outputSection.hidden = Condition.function([K.Tag.inputFieldTag], outputHidingConditionClosure)
        
        form +++ outputSection
    }
    
    func updateOutput(forCurrency currency: Currency, withRate rate: Double) {
        let outputRow = outputCurrencyTextRows[currency]
        outputRow?.value = String(format: "%.2f \(currency.raw)", rate)
        outputSection.reload()
    }
    
    func displayError(withText text: String) {
        let errorTitle = NSLocalizedString("errorTitle", comment: "Error")
        let okCopy = NSLocalizedString("okCopy", comment: "Ok")
        
        let vc = UIAlertController(title: errorTitle, message: text, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: okCopy, style: .default, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    func buildChartFormField(withExchangeSet exchangeSet: ExchangeSet) {
        let chartSectionName = NSLocalizedString("comparisonChartSectionTitle", comment: K.String.comparisonChartSectionTitleComment)
        
        chartVC = mainStoryboard.instantiateViewController(withIdentifier: K.ViewController.chartVC) as? ChartViewController
        chartVC?.setData(exchangeSet)
        
        let viewRow = ViewRow<UIView>().cellSetup { [unowned self] (cell, row) in
            self.invokeChartCreation(intoCell: cell, withSet: exchangeSet)
        }
        
        chartSection = Section(chartSectionName) <<< viewRow
        chartSection.hidden = Condition.function([K.Tag.inputFieldTag], outputHidingConditionClosure)
        form +++ chartSection
    }
    
    func updateChart(withExchangeSet exchangeSet: ExchangeSet) {
        chartVC?.setData(exchangeSet)
    }
    
    // MARK: Private Operations
    
    private func invokeChartCreation(intoCell cell: ViewCell<UIView>, withSet exchangeSet: ExchangeSet) {
        guard let chartVC = chartVC else {
            return
        }
        
        beginAppearanceTransition(true, animated: true)
        
        let containerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: chartVC.view.width, height: K.Measure.chartHeight)))
        containerView.addSubview(chartVC.view)
        
        chartVC.view.snp.makeConstraints({ (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        })
        
        cell.view = containerView
        cell.viewTopMargin = K.Measure.polesMargin
        cell.viewBottomMargin = K.Measure.polesMargin
        
        endAppearanceTransition()
        chartVC.setData(exchangeSet)
    }
    
    private func outputHidingConditionClosure(_ form: Form) -> Bool {
        guard let inputTextRow = form.rowBy(tag: K.Tag.inputFieldTag) as? TextRow else {
            return true
        }
        
        guard let value = inputTextRow.value, let intValue = Int(value) else {
            let allRatesArePresent = presenter.currentValues.all(matching: { currency, rate -> Bool in
                return rate != nil
            })
            
            return !allRatesArePresent
        }
        
        return intValue <= 0
    }
    
    private func outputCellSetup(cell: TextCell, row: TextRow) {
        cell.textField.isEnabled = false
        cell.textField.isUserInteractionEnabled = false
    }

}

