//
//  AnimationNavView.swift
//  ClosureExample
//
//  Created by Tim Yoon on 8/16/22.
//

import SwiftUI

struct AnimateCheckMark: View {
    @Binding var isDone : Bool
    @State var scale = 0.5
    
    var body: some View {
        
        Image(systemName: "circle")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(isDone ? .green : .blue)
            .gesture(
                TapGesture(count: 1)
                    .onEnded({ _ in
                        withAnimation {
                            isDone.toggle()
                            if isDone {
                                scale = 1.0
                            } else {
                                scale = 0.9
                            }
                        }
                        
                    })
            )
            .background(
                Image(systemName: isDone ? "checkmark.circle" : "circle")
                    .resizable()
//                    .opacity(isDone ? 1.0 : 0.0)
                    .scaleEffect(scale)
                    .animation(.easeOut(duration: 0.5), value: scale)
                    .foregroundColor(.green)
            )
        
    }
}

//struct AnimationNavView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimateCheckMark()
//    }
//}
