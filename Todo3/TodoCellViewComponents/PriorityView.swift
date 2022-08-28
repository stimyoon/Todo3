//
//  PriorityView.swift
//  Todo2
//
//  Created by Tim Yoon on 8/14/22.
//

import SwiftUI

extension Priority {
    var number : Int {
        switch self {
            
        case .low:
            return 1
        case .medium:
            return 2
        case .high:
            return 3
        }
    }
}


struct PriorityView: View {
    let todo : Todo
    var body: some View {
        VStack(spacing: 2){
            Spacer()
            StackedRectangles(number: todo.priority.number, maxNumber: 3)
            Text("P").font(.caption)
        }
        .frame(maxHeight: 50)
    }
}
struct PriorityView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityView(todo: Todo(priority: Priority.high))
            .previewLayout(.sizeThatFits)
        PriorityView(todo: Todo(priority: Priority.low))
            .previewLayout(.sizeThatFits)
    }
}
