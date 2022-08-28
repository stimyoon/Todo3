//
//  Color.swift
//  Todo3
//
//  Created by Tim Yoon on 8/24/22.
//

import Foundation
import SwiftUI

enum CategoryColor: Int, Identifiable, CaseIterable {
    case accent, secondary, green, red, purple, brown, teal, clear
    var id : Self {
        self
    }
    var color : Color {
        switch self {
        case .accent:
            return .accentColor
        case .secondary:
            return .secondary
        case .green:
            return .green
        case .red:
            return .red
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .teal:
            return .teal
        case .clear:
            return .clear
        }
    }
}
