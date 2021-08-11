//
//  InfoView.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/6/21.
//

import SwiftUI

struct InfoView: View {
    @Binding var categoryName: String
    @Binding var percentage: Double
    var body: some View {
        VStack {
            if percentage != 0 {
                Text(
                    categoryName
                )
                .font(.title)
                .foregroundColor(.black)
                Text(
                    percentage > 1 ? "\(Int(percentage.rounded()))%" : "<1%"
                )
                .font(.subheadline)
                .foregroundColor(.black)
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(
            categoryName: .constant("Food"),
            percentage: .constant(12)
        )
    }
}
