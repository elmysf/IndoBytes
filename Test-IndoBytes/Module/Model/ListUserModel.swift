//
//  ListUserModel.swift
//  Test-IndoBytes
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation

struct ListUserModel: Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: DetailAdressModel
    let phone: String
    let website: String
    let imageTumbnail: URL?
    let imageDetailUser: URL?
}

struct DetailAdressModel {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
