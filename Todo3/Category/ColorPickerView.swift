//
//  ColorPickerView.swift
//  Todo3
//
//  Created by Tim Yoon on 8/24/22.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor : CategoryColor
    var body: some View {
        Picker("Color", selection: $selectedColor) {
            ForEach(CategoryColor.allCases, id: \.self){ color in
                color.color
                    .foregroundColor(color.color)
                    .frame(height: 40)
                    .frame(width: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                ColorPickerView(selectedColor: .constant(CategoryColor.clear))
            }
        }
    }
}
