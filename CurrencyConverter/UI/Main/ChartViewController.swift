//
//  ChartViewController.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import UIKit
import Charts

protocol ChartViewControllerProtocol {
    
    func setData(_ set: ExchangeSet)
    
}

class ChartViewController: UIViewController, ChartViewControllerProtocol {
    
    // MARK: - INSTANCE MEMBERS
    
    // MARK: Outlets
    
    @IBOutlet weak var barChart: BarChartView!
    
    // MARK: Stored Properties
    
    private var currentValues: ExchangeSet! {
        didSet {
            if barChart != nil {
                updateChart()
            }
        }
    }
    
    // MARK: - INSTANCE OPERATIONS
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setData(currentValues)
    }
    
    // MARK: Private Operations
    
    private func setupBarChart() {
        barChart.delegate = self
        
        barChart.chartDescription?.enabled = false
        barChart.maxVisibleCount = 30
        barChart.pinchZoomEnabled = false
        barChart.dragEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.autoScaleMinMaxEnabled = true
        barChart.doubleTapToZoomEnabled = false
        
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.valueFormatter = self
        
        barChart.legend.enabled = false
    }
    
    // MARK: Exposed Operations -> Protocol Exposed
    
    func setData(_ set: ExchangeSet) {
        self.currentValues = set
    }
    
    func updateChart() {
        let entries = currentValues.map { (currency: Currency, rate: Double?) -> BarChartDataEntry in
            let actualRate = rate ?? 0.0
            return BarChartDataEntry(x: Double(currency.asInteger), y: actualRate)
        }
        
        var theSet: BarChartDataSet! = nil
        
        if let set = barChart.data?.dataSets.first as? BarChartDataSet {
            theSet = set
            theSet?.replaceEntries(entries)
            barChart.data?.notifyDataChanged()
            barChart.notifyDataSetChanged()
        } else {
            theSet = BarChartDataSet(entries: entries, label: nil)
            theSet.colors = ChartColorTemplates.material()
            theSet.drawValuesEnabled = true
            
            let data = BarChartData(dataSet: theSet)
            barChart.data = data
            barChart.fitBars = true
        }
        
        barChart.setNeedsDisplay()
        barChart.fitScreen()
    }

}

extension ChartViewController : ChartViewDelegate {
    
    
    
}

extension ChartViewController : IAxisValueFormatter {
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        return Currency.from(int: Int(value)).raw
    }
    
}
