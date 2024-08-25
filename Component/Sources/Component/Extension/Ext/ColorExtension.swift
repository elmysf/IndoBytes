//
//  ColorExtension.swift
//  
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI

public struct ColorExtension {
    public init () {}
}

public enum ColorTheme {
    case baseBackground
    case backgroundWhite
    case textColor
    case overlayColor
}

public extension Color {
    init(hex: String) {
        let color = UIColor(hex: hex)
        self.init(color)
    }
    static let baseBackground = Color(hex: "#F9F5F2")
    static let backgroundWhite = Color(hex: "#FFFFFF")
    static let textColor = Color(hex: "#000000")
    static let overlayColor = Color(hex: "#F7D6B4")
}

private extension UIColor {
    convenience init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let hexString = cleanedHex.hasPrefix("#") ? String(cleanedHex.dropFirst()) : cleanedHex
        guard hexString.count == 6 else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

public extension ColorTheme {
    var value: Color {
        switch self {
        case .baseBackground:
            return .baseBackground
        case .textColor:
            return .textColor
        case .overlayColor:
            return .overlayColor
        case .backgroundWhite:
            return .backgroundWhite
        }
    }
}
