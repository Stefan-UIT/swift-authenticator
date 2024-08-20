//
//  SettingType.swift
//  ColorNote
//
//  Created by Trung Vo on 6/24/24.
//

import Foundation
import SwiftUI

enum SettingType {
    // Export Section
    case copyToClipboard // "doc.on.doc"
    case exportPlainText // "text.alignleft"
    case exportTxtFile // "doc.text"
    case exportZipFile // "doc.zipper"
    
    // About Section
    case shareApp
    case contactUs
    case privacyPolicy
    case termOfUse
    
    var title: String {
        switch self {
            case .copyToClipboard:
                return "Copy to Clipboard"
            case .exportPlainText:
                return "as Plain Text"
            case .exportTxtFile:
                return "as .txt File"
            case .exportZipFile:
                return "as .zip File"
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
    
    private var imageName: String {
        switch self {
            case .copyToClipboard:
                return "doc.on.doc"
            case .exportPlainText:
                return "text.alignleft"
            case .exportTxtFile:
                return "doc.text"
            case .exportZipFile:
                return "doc.zipper"
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
    
    var image: Image {
        Image(systemName: imageName)
    }
    
    var url: String? {
        switch self {
        case .shareApp:
            return "https://apps.apple.com/vn/app/notes-color-best-notepad/id6504361698"
        case .privacyPolicy:
            return "https://luxmedia.top/notes-color-privacy-policy"
        case .termOfUse:
            return "https://luxmedia.top/notes-color-terms-and-conditions"
        case .contactUs:
            return "https://luxmedia.top/notes-color-feedback"
        default:
            return nil
        }
    }
}
