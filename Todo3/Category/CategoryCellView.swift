//
//  CategoryCellView.swift
//  Todo3
//
//  Created by Tim Yoon on 8/26/22.
//

import SwiftUI

struct CategoryCellView: View {
    let category: Category
    var body: some View {
        VStack(spacing: 2){
            Text("\(category.name)")
                .font(.caption)
            
            category.color.color
                .opacity(0.4)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(width: 50)
    }
}

struct CategoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCellView(category: Category(color: CategoryColor.teal, name: "Work"))
            .previewLayout(.sizeThatFits)
    }
}
