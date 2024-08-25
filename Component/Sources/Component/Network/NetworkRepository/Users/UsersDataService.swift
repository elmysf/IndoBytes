//
//  UsersDataService.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import Combine
import SwiftUI

public final class UsersDataService {
    public init() {}

    private let users = UsersContract()
    
    public func fetchUserInfo() -> AnyPublisher<UsersResponse, Error> {
        let url = URLComponents(string: users.endpoint)!
        var request = URLRequest(url: url.url!)
        request.httpMethod = users.type
        print("URL Response users: \(url)")
        return NetworkingManager
            .get(for: request)
    }
}
