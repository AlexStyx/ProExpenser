//
//  ChartCircle.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import SwiftUI

struct ChartView: View {
    @State private var categoryName: String = ""
    @State private var percentage: Int = 0
    @ObservedObject var chartDataObject: ChartContainer
    var body: some View {
        VStack {
            TotalAmountView(chartDataObject: chartDataObject)
            ZStack {
                CircleView(chartDataObject: chartDataObject, categoryName: $categoryName, percentage: $percentage)
                InfoView(categoryName: $categoryName, percentage: $percentage)
            }
        }
    }
}

struct ChartCircle_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(chartDataObject: ChartContainer(period: .day))
    }
}
