//
//  HeaderStyle.swift
//  
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI

public struct HeaderStyle: ViewModifier {
    let backgroundColor: Color

    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }

    public func body(content: Content) -> some View {
        content
            .padding(.top, UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first?
                .safeAreaInsets.top ?? 0)
            .background(backgroundColor)
    }
}
