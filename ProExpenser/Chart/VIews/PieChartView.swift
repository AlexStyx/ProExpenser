//
//  PieChartView.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/30/21.
//

import SwiftUI

struct PieChartView: View {
    
    @State private var period: SpendCategoryContainer.Period = .day
    @State private var expenseItemName: String = ""
    @State private var expenseItemPercent: Int = 0
    @State private var totalAmount: Double = 1.00
    
    var body: some View {
        VStack {
            Picker("SelectPeriod", selection: $period) {
                ForEach(SpendCategoryContainer.Period.allCases) { period in
                    Text(period.rawValue)
                        .tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .padding(.top, 20)
            
            ChartView(chartDataObject: ChartContainer(period: period))
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
    }
}
