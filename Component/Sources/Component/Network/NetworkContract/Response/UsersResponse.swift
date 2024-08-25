//
//  UsersResponse.swift
//  
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation

public typealias UsersResponse = [UserData]

public struct UserData: Codable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let address: AddressData
    public let phone: String
    public let website: String
    public let company: CompanyData
}

public struct AddressData: Codable {
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    public let geo: GeoData
}

public struct GeoData: Codable {
    public let lat: String
    public let lng: String
}

public struct CompanyData: Codable {
    public let name: String
    public let catchPhrase: String
    public let bs: String
}
