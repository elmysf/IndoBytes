//
//  UserDetailView.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import SwiftUI
import Component

/// `UserDetailView` is a SwiftUI view that displays detailed information about a user.
/// This view shows the user's profile picture, name, and other details such as username, email, address, phone number, and website.
struct UserDetailView: View {
    // MARK: - Environment Properties
    /// The environment property used to manage the presentation mode, allowing the view to be dismissed.
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: - Properties
    /// The user model containing the detailed information to be displayed in the view.
    var user: ListUserModel
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                // Custom header with a title and a close button.
                CustomHeaderNavigation(
                    left: {},
                    center: {
                        Text("Profile")
                            .font(.WorkSans.styleFont(.semiBold, size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                    },
                    right: {
                        Button(action: {
                            // Dismisses the view when the close button is pressed.
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image.icClosed
                                .resizable()
                                .frame(width: 30, height: 30)
                        })
                    }
                )
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 28)
            .modifier(HeaderStyle(backgroundColor: ColorTheme.backgroundWhite.value))
            
            // Divider separating the header from the content.
            Divider()
                .background(Color.black)
                .frame(height: 2)
            
            ZStack {
                // Background color of the view.
                ColorTheme.baseBackground.value
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    VStack(alignment: .center, spacing: 8) {
                        // User profile image.
                        AsyncImage(url: user.imageDetailUser) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(ColorTheme.textColor.value, lineWidth: 2))
                        .padding(.top, 30)
                        
                        // User name.
                        Text(user.name)
                            .font(.WorkSans.styleFont(.semiBold, size: 32))
                            .padding(.vertical, 20)
                        
                        // User details including username, email, address, phone, and website.
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 37) {
                                Text("USERNAME")
                                    .font(.WorkSans.styleFont(.semiBold, size: 16))
                                Text(user.username)
                                    .font(.WorkSans.styleFont(.regular, size: 16))
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            HStack(spacing: 75) {
                                Text("EMAIL")
                                    .font(.WorkSans.styleFont(.semiBold, size: 16))
                                Text(user.email)
                                    .font(.WorkSans.styleFont(.regular, size: 16))
                            }
                            .padding(.horizontal, 20)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 50) {
                                Text("ADDRESS")
                                    .font(.WorkSans.styleFont(.semiBold, size: 16))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.address.street)
                                    Text(user.address.suite)
                                    Text(user.address.city)
                                    Text(user.address.zipcode)
                                }
                                .font(.WorkSans.styleFont(.regular, size: 16))
                                .alignmentGuide(.firstTextBaseline) { $0[.firstTextBaseline] }
                            }
                            .padding(.horizontal, 20)
                            
                            HStack(spacing: 70) {
                                Text("PHONE")
                                    .font(.WorkSans.styleFont(.semiBold, size: 16))
                                Text(user.phone)
                                    .font(.WorkSans.styleFont(.regular, size: 16))
                            }
                            .padding(.horizontal, 20)
                            
                            HStack(spacing: 50) {
                                Text("WEBSITE")
                                    .font(.WorkSans.styleFont(.semiBold, size: 16))
                                Text(user.website)
                                    .font(.WorkSans.styleFont(.regular, size: 16))
                                    .frame(alignment: .leading)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(ColorTheme.backgroundWhite.value)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(ColorTheme.textColor.value, lineWidth: 1))
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
