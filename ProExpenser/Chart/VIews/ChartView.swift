//
//  ChartCircle.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import SwiftUI

struct ChartView: View {
    @State private var categoryName: String = ""
    @State private var percentage: Double = 0
    @State private var indexOfTappedSlice = -1
    @ObservedObject var chartDataObject: ChartContainer
    var body: some View {
        VStack {
            TotalAmountView(chartDataObject: chartDataObject)
                .padding(.top, 15)
            if chartDataObject.total > 0 {
                ZStack {
                    CircleView(chartDataObject: chartDataObject, indexOfTappedSlice: $indexOfTappedSlice, categoryName: $categoryName, percentage: $percentage, onTapPieceOfPieAction: scalePie(at:))
                    InfoView(categoryName: $categoryName, percentage: $percentage)
                }
                CategoryList(chartDataObject: chartDataObject, action: scalePie(at:))
            }
        }
    }
    
    private func scalePie(at index: Int) {
        if indexOfTappedSlice == index {
            indexOfTappedSlice = -1
            categoryName = ""
            percentage = 0
        } else {
            indexOfTappedSlice = index
            categoryName = chartDataObject.chartItems[index].name
            percentage = Double(chartDataObject.chartItems[index].percent.rounded())
        }
    }
}

struct ChartCircle_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(chartDataObject: ChartContainer(period: .day))
    }
}
