//
//  View+Extension.swift
//  Health
//
//  Created by Tim Yoon on 3/6/22.
//

import SwiftUI

extension View {
    func centerHorizontaly() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


