//
//  NetworkManager.swift
//  
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI
import Combine

public enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public protocol BaseNetwork {
    var endpoint: String { get }
    var type: String { get }
    var params: [String: Any] { get }
}

public extension BaseNetwork {
    var params: [String: Any] {
        [:]
    }
}

public struct Errors: Decodable {
    let timestamp: Int
    let status: String
    let message: String
}

public class NetworkingManager {
    public init() {}

    enum NetworkingError: LocalizedError {
        case badURLResponse(url: String)
        case unauthorizedAccess
        case unknown

        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "Bad URL response for URL: \(url)"
            case .unauthorizedAccess:
                return "Unauthorized access: You do not have permission to access this resource."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }

    public static func get<T: Decodable>(for url: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession(configuration: .ephemeral)
            .dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }

    public static func handleURLResponse<T: Decodable>(output: URLSession.DataTaskPublisher.Output, url: URLRequest) throws -> T {
        if let response = output.response as? HTTPURLResponse {
            if response.statusCode == 401 {
                // Throw an error indicating unauthorized access
                throw NetworkingError.unauthorizedAccess
            }
        }

        guard let response = output.response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            let jsonResp = try JSONSerialization.jsonObject(with: output.data, options: []) as? [String: Any]
            let errorMessage = jsonResp?["message"] as? String ?? "Unknown error occurred"
            throw NetworkingError.badURLResponse(url: errorMessage)
        }
        return try JSONDecoder().decode(T.self, from: output.data)
    }
    
    public static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Network request failed with error: \(error.localizedDescription)")
        }
    }
}
