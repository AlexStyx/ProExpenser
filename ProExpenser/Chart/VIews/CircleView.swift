//
//  CircleView.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/6/21.
//

import SwiftUI

struct CircleView: View {
    @ObservedObject var chartDataObject: ChartContainer
    @Binding var indexOfTappedSlice: Int
    @Binding var categoryName: String
    @Binding var percentage: Int
    
    var action: ((Int) -> ())?
    
    var body: some View {
        ZStack {
            ForEach(0..<chartDataObject.chartItems.count) { index in
                Circle()
                    .trim(
                        from: index == 0 ? 0.0 : chartDataObject.chartItems[index - 1].value / 100,
                        to: chartDataObject.chartItems[index].value / 100
                    )
                    .stroke(chartDataObject.chartItems[index].color, lineWidth: 40)
                    .scaleEffect(index == indexOfTappedSlice ? 1.1 : 1.0)
                    .animation(.spring())
                    .onTapGesture {
                        action?(index)
                    }
            }
        }
        .frame(width: 200, height: 250)
    }
    
    private func scalePie(at index: Int) {
        if indexOfTappedSlice == index {
            indexOfTappedSlice = -1
            categoryName = ""
            percentage = 0
        } else {
            indexOfTappedSlice = index
            categoryName = chartDataObject.chartItems[index].name
            percentage = Int(chartDataObject.chartItems[index].percent.rounded())
        }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(
            chartDataObject: ChartContainer(period: .day),
            indexOfTappedSlice: .constant(-1),
            categoryName: .constant("Food"),
            percentage: .constant(12),
            action: nil
        )
    }
}
