//
//  SearchView.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import SwiftUI
import Components

struct SearchView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            HStack {
                TextField("", text: $searchText, onEditingChanged: { changed in
                }, onCommit: {
                })
                .modifier(PlaceholderStyle(showPlaceHolder: searchText.isEmpty,
                                           placeholder: "Search"))
                .modifier(SearchBarStyle())
                .accessibilityIdentifier("SearchField")
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        if !self.searchText.isEmpty {
                            Button(action: {
                                self.setSearchEndEditing()
                            }) {
                                Image.icClosed
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .leading)
                            }
                        }
                    }
                    .padding(.trailing, 16)
                )
            }
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            self.didTapSearchTextField()
        }
        .onDisappear {
            self.searchText = ""
        }
    }
    
    private func setSearchEndEditing() {
        self.searchText = ""
        self.isEditing = false
    }
    
    private func didTapSearchTextField() {
        self.isEditing = true
    }
}
