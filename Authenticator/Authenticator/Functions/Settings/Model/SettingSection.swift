//
//  SettingSection.swift
//  Authenticator
//
//  Created by Trung Vo on 21/08/2024.
//

import Foundation

struct SettingSection: Identifiable {
    var id = UUID()
    var title: String
    var items: [SettingType]
}
