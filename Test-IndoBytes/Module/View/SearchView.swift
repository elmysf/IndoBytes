//
//  SearchView.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import SwiftUI
import Component

/// `SearchView` is a custom SwiftUI view that provides a search bar with a clear button.
/// The search bar allows users to input text, and the clear button appears when there is text in the search bar.
struct SearchView: View {
    // MARK: - Properties
    /// The binding to the search text that the parent view can use to access and update the search query.
    @Binding var searchText: String
    
    /// A local state to track whether the search bar is currently being edited.
    @State private var isEditing = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            HStack {
                TextField("", text: $searchText, onEditingChanged: { changed in
                    // Handle the state when editing begins or ends (not currently implemented).
                }, onCommit: {
                    // Handle the action when the user presses the return key (not currently implemented).
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
    
    // MARK: - Private Methods
    /// Clears the search text and sets the editing state to `false`.
    private func setSearchEndEditing() {
        self.searchText = ""
        self.isEditing = false
    }
    
    /// Sets the editing state to `true` when the search text field is tapped.
    private func didTapSearchTextField() {
        self.isEditing = true
    }
}

