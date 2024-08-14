//
//  TabBarSettings.swift
//  Authenticator
//
//  Created by Trung Vo on 13/08/2024.
//

import SwiftUI

class TabBarSettings: ObservableObject {
    @Published var selectedItem: Int = 0
    @Published var visibility: Visibility = .visible
}

