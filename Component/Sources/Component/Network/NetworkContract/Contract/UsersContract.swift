//
//  UsersContract.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation

public struct UsersContract: BaseNetwork {
    public init () { }
    public var endpoint: String {
        BaseURL.userURL
     }
    public var type: String{
         HTTPMethodType.get.rawValue
     }
 }
