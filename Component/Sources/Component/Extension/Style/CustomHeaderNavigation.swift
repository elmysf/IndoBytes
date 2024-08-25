//
//  CustomHeaderNavigation.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI

public struct CustomHeaderNavigation<Left, Center, Right>: View where Left: View, Center: View, Right: View {
    public let left: () -> Left
    public let center: () -> Center
    public let right: () -> Right
    
    public init(@ViewBuilder left: @escaping () -> Left, @ViewBuilder center: @escaping () -> Center, @ViewBuilder right: @escaping () -> Right) {
        self.left = left
        self.center = center
        self.right = right
    }
    public var body: some View {
        ZStack {
            HStack {
                left()
                Spacer()
            }
            center()
            HStack {
                Spacer()
                right()
            }
        }
    }
}
