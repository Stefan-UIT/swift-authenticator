//
//  AlertKitHelper.swift
//  Authenticator
//
//  Created by Trung Vo on 16/08/2024.
//

import Foundation
import AlertKit

struct AlertKitHelper {
    static func show(title: String? = nil,
                     subtitle: String? = nil,
                     icon: AlertIcon? = nil,
                     style: AlertViewStyle,
                     haptic: AlertHaptic? = nil) {
        AlertKitAPI.present(title: title, subtitle: subtitle, icon: icon, style: style, haptic: haptic)
    }
}
