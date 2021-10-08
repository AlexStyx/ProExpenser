//
//  CategoryRow.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/7/21.
//

import SwiftUI

struct CategoryRow: View {
    var pieceOfPie: PieceOfPie
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(pieceOfPie.color)
            Text(pieceOfPie.name)
            Spacer()
            Text(Int(pieceOfPie.percent.rounded()) < 1 ? Int(pieceOfPie.percent.rounded()) == 0 ? "0%" : "<1%" : "\(Int(pieceOfPie.percent.rounded()))%")
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(pieceOfPie:PieceOfPie(spendCategoryContainer: SpendCategoryContainer(spendCategory: SpendCategory(), period: .day), total: 100, color: Color.red))
    }
}
