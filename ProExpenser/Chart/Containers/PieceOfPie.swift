//
//  PieceOfpie.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import SwiftUI

struct PieceOfPie: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let name: String
    let percent: CGFloat
    var value: CGFloat = 0
    
    init(spendCategoryContainer: SpendCategoryContainer, total: Double, color: Color) {
        self.color = color
        self.name = spendCategoryContainer.name
        self.percent = CGFloat(spendCategoryContainer.total / (total / 100))
    }
}


extension Array where Element: Numeric {
    var sum: Element {
        self.reduce(0, +)
    }
}
