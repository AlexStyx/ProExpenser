//
//  InfoView.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/6/21.
//

import SwiftUI

struct InfoView: View {
    @Binding var categoryName: String
    @Binding var percentage: Int
    var body: some View {
        VStack {
            Text(categoryName)
                .font(.title)
            Text(
                percentage == 0 ? "" : "\(percentage)%"
            )
                .font(.subheadline)
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
