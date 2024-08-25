//
//  Fonts.swift
//
//
//  Created by Sufiandy Elmy on 25/08/24.
//

import Foundation
import SwiftUI

public struct WorkSansFonts {
    public let name: String
    
    private init(named name: String) {
        self.name = name
        do {
            try registerFont(named: name)
        } catch {
            let reason = error.localizedDescription
            fatalError("Failed to register font: \(reason)")
        }
    }
    
    public static let regular = WorkSansFonts(named: "WorkSans-Regular")
    public static let medium = WorkSansFonts(named: "WorkSans-Medium")
    public static let semiBold = WorkSansFonts(named: "WorkSans-SemiBold")
}
