//
//  ChartContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import SwiftUI

class ChartContainer: ObservableObject{
    private let coreDataService = CoreDataService()
    @Published var chartItems: [PieceOfPie] = []
    @Published var period: SpendCategoryContainer.Period
    @Published var total: Double = 0
    var colors = [UIColor.red, .gray, .yellow, .green, .orange, .purple, .blue, .black, #colorLiteral(red: 1, green: 0.410033524, blue: 0.8203747869, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.9777814746, alpha: 1), #colorLiteral(red: 0.6234099865, green: 0.3937651515, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7859703898, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.7272937298, alpha: 1), #colorLiteral(red: 0.7800317407, green: 0.9913412929, blue: 0.5462956429, alpha: 1)]
    
    private lazy var spendCategories = coreDataService.getCategories()
    
    private func computeChartItemsAndTotal() -> ([PieceOfPie], Double) {
        var totalAmount: Double = 0
        var chartItems = [PieceOfPie]()
        if let spendCategories = spendCategories {
            let spendCategoryContainers = spendCategories.map { SpendCategoryContainer(spendCategory: $0, period: period)}
            spendCategoryContainers.forEach { totalAmount += $0.total }
            if totalAmount > 0 {
                for container in spendCategoryContainers {
                    let color = Color(colors.remove(at: colors.count.arc4random))
                    let pieceOfPie = PieceOfPie(spendCategoryContainer: container, total: totalAmount, color: color)
                    chartItems.append(pieceOfPie)
                }
            }
        }
        colors = [UIColor.red, .gray, .yellow, .green, .orange, .purple, .blue, .black, #colorLiteral(red: 1, green: 0.410033524, blue: 0.8203747869, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.9777814746, alpha: 1), #colorLiteral(red: 0.6234099865, green: 0.3937651515, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7859703898, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0.7272937298, alpha: 1), #colorLiteral(red: 0.7800317407, green: 0.9913412929, blue: 0.5462956429, alpha: 1)]
        
        return (chartItems, totalAmount)
    }
    
    func calcOfPath() {
        var value: CGFloat = 0
        for index in 0..<chartItems.count {
            value += chartItems[index].percent
            chartItems[index].value = value
        }
    }
    
    init(period: SpendCategoryContainer.Period) {
        self.period = period
        (self.chartItems, self.total) = computeChartItemsAndTotal()
        calcOfPath()
    }
}



