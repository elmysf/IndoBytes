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

public class UsersViewModel: ObservableObject {
    @Published var userData: [ListUserModel] = []
    @Published var searchQuery: String = ""
    @Published var showModal: Bool = false
    @Published var selectedUser: ListUserModel? = nil
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isConnected: Bool = true
    @Published var isLoading: Bool = false
    
    private let dataService = UsersDataService()
    private var cancellables = Set<AnyCancellable>()
    private var timeoutTimer: Timer?
    
    public init() { }
    
    public func checkInternetAndFetchUser() {
        checkNetworkConnectivity { [weak self] isConnected in
            if !isConnected {
                self?.handleError(.noInternet)
            } else {
                self?.fetchUser()
            }
        }
    }
    
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
    
    private func startTimeoutTimer() {
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            self?.checkNetworkConnectivity { isConnected in
                if !isConnected {
                    self?.handleError(.noInternet)
                } else {
                    self?.handleError(.fetchFailed("Request timed out. Please try again later."))
                }
            }
        }
    }
    
    private func invalidateTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
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
}

enum FetchError: Error {
    case noInternet
    case fetchFailed(String)
}

