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
                return "Copy URIs"
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
                return "copy"
            case .exportPlainText:
                return "raw-text"
            case .exportTxtFile:
                return "txt-file"
            case .exportZipFile:
                return "zip"
        case .shareApp:
            return "share"
        case .contactUs:
            return "contact-us"
        case .privacyPolicy:
            return "privacy-policy"
        case .termOfUse:
            return "term-of-use"
        }
    }
    
    var image: Image {
        return Image(imageName)
    }
    
    var imageSize: CGSize {
        return CGSize(width: 32, height: 32)
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
