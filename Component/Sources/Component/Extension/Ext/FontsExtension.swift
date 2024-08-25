//
//  FontsExtension.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI

public struct FontsExtension {
    public init () {}
}

extension Font {
    public struct WorkSans {
        public static func styleFont(_ style: WorkSansFonts, size: CGFloat) -> Font {
           return Font.custom(style.name, size: size)
        }
    }
}
