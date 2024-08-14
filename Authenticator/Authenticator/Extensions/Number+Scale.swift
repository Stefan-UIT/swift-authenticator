//
//  Number+Scale.swift
//  Authenticator
//
//  Created by Trung Vo on 14/08/2024.
//

import UIKit

protocol ScalableNumeric {}
extension ScalableNumeric {
    var minScaled: CGFloat {
        guard let number = self as? NSNumber else { return 0 }
        return CGFloat(truncating: number) * DeviceHelper.minScaleFactor
    }
    
    var maxScaled: CGFloat {
        guard let number = self as? NSNumber else { return 0 }
        return CGFloat(truncating: number) * DeviceHelper.maxScaleFactor
    }
}

extension Int: ScalableNumeric {}
extension CGFloat: ScalableNumeric {}

enum DeviceHelper {
    // Base width in point, use iPhone 11 Pro
    private static let basedSize = CGSize(width: 375, height: 812)

    static var widthScaleFactor: CGFloat {
        return UIScreen.width / basedSize.width
    }
    
    private static var heightScaleFactor: CGFloat {
        return UIScreen.height / basedSize.height
    }
    
    static var minScaleFactor: CGFloat {
        return min(widthScaleFactor, heightScaleFactor)
    }
    
    static var maxScaleFactor: CGFloat {
        return min(widthScaleFactor, heightScaleFactor)
    }
}

extension UIScreen {
    static let width = size.width
    static let height = size.height
    static let size = UIScreen.main.bounds.size
}


