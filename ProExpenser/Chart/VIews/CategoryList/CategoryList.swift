//
//  CategoryList.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/7/21.
//

import SwiftUI

struct CategoryList: View {
    @ObservedObject var chartDataObject: ChartContainer
    var action: ((Int) -> ())?
    var body: some View {
        ForEach(chartDataObject.chartItems) { chartItem in
            CategoryRow(pieceOfPie: chartItem)
                .onTapGesture {
                    action?(chartDataObject.chartItems.firstIndex(of: chartItem)!)
                }
        }
        .padding(10)
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList(chartDataObject: ChartContainer(period: .day))
    }
}
