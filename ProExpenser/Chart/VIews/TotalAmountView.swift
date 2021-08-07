//
//  TotalAmountView.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/7/21.
//

import SwiftUI

struct TotalAmountView: View {
    @ObservedObject var chartDataObject: ChartContainer
    var body: some View {
        Text("Total: " + String(format: "%.2f", chartDataObject.total))
            .font(.largeTitle)
    }
}

struct TotalAmountView_Previews: PreviewProvider {
    static var previews: some View {
        TotalAmountView(chartDataObject: ChartContainer(period: .day))
    }
}
