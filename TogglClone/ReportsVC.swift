//
//  ViewController.swift
//  TogglClone
//
//  Created by user on 2/21/22.
//

import UIKit
import Charts


class ReportsVC: UIViewController {
    
    
    @IBOutlet weak var barView: BarChartView!
    
    @IBOutlet weak var pieView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createBarChart()
        createPieChart()
    }
    
    func createBarChart() {
        var dataEntries: [ChartDataEntry] = []
        var data = TimeEntry.aggregateDayDuration(TimeEntry.dummyEntries)
        
        for (i, item) in data.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: item.value)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barView.data = chartData
        barView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Array(data.keys))
        barView.xAxis.granularity = 1
        barView.xAxis.labelPosition = .bottom
        
    }
    
    func createPieChart() {
        var dataEntries: [ChartDataEntry] = []
        var data = TimeEntry.aggregateProjectDuration(TimeEntry.dummyEntries)
        
        for (i, item) in data.enumerated() {
            let dataEntry = PieChartDataEntry(value: item.value, data: item.key)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(entries: dataEntries)
        chartDataSet.colors = [UIColor.lightGray, UIColor.yellow, UIColor.red]

        let chartData = PieChartData(dataSet: chartDataSet)

        pieView.data = chartData
    }


}

