//
//  UIWindow+Extensions.swift
//  ColorNote
//
//  Created by Trung Vo on 29/05/2024.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}

