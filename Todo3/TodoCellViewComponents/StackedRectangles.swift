//
//  StackedRectangles.swift
//  Todo2
//
//  Created by Tim Yoon on 8/14/22.
//

import SwiftUI

struct StackedRectangles: View {
    let number : Int
    let maxNumber : Int
    var body: some View {
        VStack(spacing: 2){
            ForEach(0..<maxNumber, id: \.self){index in
                Rectangle()
                    .fill(maxNumber-number > index ? Color.clear : Color.primary.opacity(0.6))
                    .background(content: {
                        Rectangle()
                            .fill(Color.primary.opacity(0.2))
                    })
                    .frame(width: 10, height: 2)
            }
        }
    }
}

struct StackedRectangles_Previews: PreviewProvider {
    static var previews: some View {
        StackedRectangles(number: 3, maxNumber: 3)
            .previewLayout(.sizeThatFits)
        StackedRectangles(number: 1, maxNumber: 3)
            .previewLayout(.sizeThatFits)
    }
}
