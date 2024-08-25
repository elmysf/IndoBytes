//
//  SearchStyle.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI


public struct PlaceholderStyle: ViewModifier {
    public init(showPlaceHolder: Bool, placeholder: String ) {
        self.showPlaceHolder = showPlaceHolder
        self.placeholder = placeholder
   }
    
   public var showPlaceHolder: Bool
   public var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .font(.WorkSans.styleFont(.medium, size: 18))
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }
            content
                .font(.WorkSans.styleFont(.medium, size: 18))
                .foregroundStyle(Color.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
        }
    }
}

public struct SearchBarStyle: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
        .padding(.horizontal, 20)
        .background(ColorTheme.backgroundWhite.value)
        .clipShape(RoundedRectangle(cornerRadius:10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(ColorTheme.textColor.value, lineWidth: 1))
        .disableAutocorrection(true)
    }
}
