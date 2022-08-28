//
//  DurationView.swift
//  Todo2
//
//  Created by Tim Yoon on 8/14/22.
//

import SwiftUI
extension Duration {
    var number: Int {
        switch self {
            
        case .short:
            return 1
        case .medium:
            return 2
        case .long:
            return 3
        }
    }
}
struct DurationView: View {
    let todo : Todo
    var body: some View {
        VStack(spacing: 2){
            Spacer()
            StackedRectangles(number: todo.duration.number, maxNumber: 3)
            Text("D").font(.caption)
            
        }
        .frame(maxHeight: 50)
    }
}


struct DurationView_Previews: PreviewProvider {
    static var previews: some View {
        DurationView(todo: Todo(duration: Duration.long))
            .previewLayout(.sizeThatFits)
    }
}
