//
//  SettingItem.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import Foundation

enum SettingType {
    case shareApp
    case contactUs
    case privacyPolicy
    case termOfUse
    
    var title: String {
        switch self {
        case .shareApp:
            return "Share App"
        case .contactUs:
            return "Contact Us"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termOfUse:
            return "Term of Use"
        }
    }
    
    var icon: String {
        switch self {
        case .shareApp:
            return "square.and.arrow.up"
        case .contactUs:
            return "envelope"
        case .privacyPolicy:
            return "shield.lefthalf.fill"
        case .termOfUse:
            return "book"
        }
    }
    
    var url: String {
        switch self {
        case .shareApp:
            return "https://apps.apple.com/vn/app/notes-color-best-notepad/id6504361698"
        case .privacyPolicy:
            return "https://luxmedia.top/notes-color-privacy-policy"
        case .termOfUse:
            return "https://luxmedia.top/notes-color-terms-and-conditions"
        case .contactUs:
            return "https://luxmedia.top/notes-color-feedback"
        }
    }
}
