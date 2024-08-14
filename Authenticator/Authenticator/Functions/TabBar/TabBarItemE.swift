//
//  TabBarItemE.swift
//  Authenticator
//
//  Created by Trung Vo on 13/08/2024.
//

import UIKit

enum TabBarItemE: Int {
    case home
    case setting
    
    var icon: UIImage {
        switch self {
        case .home:
                return UIImage(systemName: "house")!
        case .setting:
            return UIImage(systemName: "gear")!
        }
    }
        
        var title: String {
                switch self {
                case .home:
                        return "Home"
                case .setting:
                        return "Settings"
                }
        }
        
        var size: CGSize {
                CGSize(width: 20, height: 20)
        }
}
