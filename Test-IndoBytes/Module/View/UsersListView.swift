//
//  UsersListView.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import SwiftUI
import Component

/// `UsersListView` is a SwiftUI view that displays a list of users, allowing the user to search, view details, and handle network-related errors.
struct UsersListView: View {
    // MARK: - Properties
    /// The `UsersViewModel` instance that manages the state and data for this view.
    @StateObject var userVM = UsersViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Title of the view
                    Text("User")
                        .font(.WorkSans.styleFont(.semiBold, size: 32))
                        .padding(.bottom, 8)
                        .modifier(HeaderStyle(backgroundColor: ColorTheme.baseBackground.value))
                        .padding(.horizontal, 20)
                    
                    // Search bar and search icon
                    HStack(alignment: .center, spacing: 10) {
                        SearchView(searchText: $userVM.searchQuery)
                        
                        Spacer()
                        
                        Image.icSearch
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.top, 15)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    
                    // Label indicating if displaying all users or search results
                    VStack(alignment: .leading, spacing: 10) {
                        Text(userVM.searchQuery.isEmpty ? "ALL USER" : "SEARCH RESULTS")
                            .font(.WorkSans.styleFont(.semiBold, size: 16))
                            .foregroundStyle(ColorTheme.textColor.value)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ColorTheme.backgroundWhite.value)
                    .overlay(
                        Rectangle()
                            .inset(by: 0.5)
                            .stroke(ColorTheme.textColor.value, lineWidth: 1)
                    )
                    
                    // List of users
                    GeometryReader { proxy in
                        ScrollView(.vertical, showsIndicators: false, content: {
                            // Determine if showing all users or filtered search results
                            let usersToDisplay = userVM.searchQuery.isEmpty ? userVM.userData : userVM.filteredUserData
                            
                            if !usersToDisplay.isEmpty {
                                ForEach(usersToDisplay, id: \.id) { item in
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 20) {
                                            // User's thumbnail image
                                            AsyncImage(url: item.imageTumbnail) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .shadow(color: ColorTheme.overlayColor.value, radius: 0, x: 2, y: 3)
                                            .overlay(Circle().strokeBorder(ColorTheme.textColor.value, lineWidth: 1))
                                            
                                            // User's name and username
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(item.name)
                                                    .font(.WorkSans.styleFont(.semiBold, size: 16))
                                                    .foregroundStyle(ColorTheme.textColor.value)
                                                Text("@\(item.username)")
                                                    .font(.WorkSans.styleFont(.regular, size: 12))
                                                    .foregroundStyle(ColorTheme.textColor.value)
                                            }
                                            
                                            // Add friend button (only visible in search results)
                                            if !userVM.searchQuery.isEmpty {
                                                Spacer()
                                                Image.icAddFriends
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                            }
                                        }
                                        .padding(.vertical, 20)
                                        .padding(.horizontal, 20)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(ColorTheme.backgroundWhite.value)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(ColorTheme.textColor.value, lineWidth: 1))
                                    .onTapGesture {
                                        // Show user detail modal when a user is selected
                                        userVM.selectedUser = item
                                        userVM.showModal = true
                                    }
                                }
                            } else if !userVM.searchQuery.isEmpty {
                                // Display message if no users are found in the search
                                Text("No users found")
                                    .font(.WorkSans.styleFont(.regular, size: 16))
                                    .foregroundStyle(ColorTheme.textColor.value)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 20)
                            }
                        })
                        .navigationBarHidden(true)
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                    }
                }
                
                // Loading indicator
                if userVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .cornerRadius(10)
                }
            }
            .background(ColorTheme.baseBackground.value)
            .ignoresSafeArea(.all)
            // Alert for handling errors (e.g., network issues)
            .alert(isPresented: $userVM.showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(userVM.errorMessage ?? ""),
                    primaryButton: .default(Text("Retry"), action: {
                        userVM.checkInternetAndFetchUser()
                    }),
                    secondaryButton: .cancel()
                )
            }
            // Fetch user data when the view appears
            .onAppear {
                userVM.checkInternetAndFetchUser()
            }
            // Modal to show user detail view
            .sheet(isPresented: $userVM.showModal) {
                if let user = userVM.selectedUser {
                    UserDetailView(user: user)
                }
            }
        }
    }
}
