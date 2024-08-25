//
//  UsersViewModel.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI
import Combine
import Network
import Component

/// `UsersViewModel` is an `ObservableObject` that manages user data fetching,
/// search functionality, error handling, and network connectivity status for SwiftUI views.
public class UsersViewModel: ObservableObject {
    // MARK: - Published Properties
    /// An array of user data to be displayed in the UI.
    @Published var userData: [ListUserModel] = []

    /// The search query entered by the user for filtering the user list.
    @Published var searchQuery: String = ""

    /// Controls the visibility of a modal in the UI.
    @Published var showModal: Bool = false

    /// The currently selected user for detailed view or editing.
    @Published var selectedUser: ListUserModel? = nil

    /// Indicates whether an error alert should be shown.
    @Published var showErrorAlert: Bool = false

    /// The message to be displayed in the error alert.
    @Published var errorMessage: String? = nil

    /// Tracks the network connectivity status.
    @Published var isConnected: Bool = true

    /// Indicates whether the view model is currently loading data.
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    /// The service responsible for fetching user data.
    private let dataService = UsersDataService()

    /// A set of `AnyCancellable` objects for managing Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()

    /// A timer for handling request timeouts.
    private var timeoutTimer: Timer?
    
    // MARK: - Initializer
    /// Initializes the `UsersViewModel`.
    public init() { }
    
    // MARK: - Public Methods
    /// Checks internet connectivity before attempting to fetch user data.
    public func checkInternetAndFetchUser() {
        checkNetworkConnectivity { [weak self] isConnected in
            if !isConnected {
                self?.handleError(.noInternet)
            } else {
                self?.fetchUser()
            }
        }
    }
    
    /// Fetches user data from the network service and updates the `userData` property.
    public func fetchUser() {
        isLoading = true
        startTimeoutTimer()
        
        dataService
            .fetchUserInfo()
            .receive(on: RunLoop.main)
            .sink { [weak self] (completion) in
                self?.invalidateTimeoutTimer()
                
                switch completion {
                case .failure(let error):
                    self?.checkNetworkConnectivity { isConnected in
                        if !isConnected {
                            self?.handleError(.noInternet)
                        } else {
                            self?.handleError(.fetchFailed(error.localizedDescription))
                        }
                    }
                case .finished:
                    print("Successfully fetched all user data")
                }
                
                self?.isLoading = false
            } receiveValue: { [weak self] (users) in
                self?.userData = users.map { item in
                    ListUserModel(id: item.id,
                                  name: item.name,
                                  username: item.username,
                                  email: item.email,
                                  address: DetailAdressModel(
                                    street: item.address.street,
                                    suite: item.address.suite,
                                    city: item.address.city,
                                    zipcode: item.address.zipcode),
                                  phone: item.phone,
                                  website: item.website,
                                  imageTumbnail: URL(string: "https://i.pravatar.cc/150"),
                                  imageDetailUser: URL(string: "https://i.pravatar.cc/1000"))
                }
            }
            .store(in: &cancellables)
    }
    
    /// Filters the `userData` based on the `searchQuery`.
    var filteredUserData: [ListUserModel] {
        if searchQuery.isEmpty {
            return userData
        } else {
            return userData.filter { user in
                user.name.localizedCaseInsensitiveContains(searchQuery) ||
                user.username.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    // MARK: - Private Methods
    /// Starts a timer to handle request timeouts.
    /// If the request takes longer than 5 seconds, triggers an error.
    private func startTimeoutTimer() {
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            self?.checkNetworkConnectivity { isConnected in
                if !isConnected {
                    self?.handleError(.noInternet)
                } else {
                    self?.handleError(.fetchFailed("Request timed out. Please try again later."))
                }
            }
        }
    }
    
    /// Invalidates the timeout timer to prevent it from triggering.
    private func invalidateTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    /// Handles errors by setting the appropriate error message and triggering the error alert.
    private func handleError(_ error: FetchError) {
        DispatchQueue.main.async {
            switch error {
            case .noInternet:
                self.errorMessage = "No internet connection. Please check your network settings."
            case .fetchFailed(let message):
                self.errorMessage = "Failed to fetch data: \(message)"
            }
            self.showErrorAlert = true
            self.isLoading = false
        }
    }
    
    /// Checks the network connectivity status using `NWPathMonitor` and returns the result in the completion handler.
    private func checkNetworkConnectivity(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                completion(path.status == .satisfied)
                monitor.cancel()
            }
        }
        monitor.start(queue: queue)
    }
}

// MARK: - FetchError Enum
/// Represents errors that can occur during the fetching of user data.
enum FetchError: Error {
    case noInternet
    case fetchFailed(String)
}
