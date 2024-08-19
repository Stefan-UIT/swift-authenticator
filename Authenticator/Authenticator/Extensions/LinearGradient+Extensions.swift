//
//  LinearGradient+Extensions.swift
//  Authenticator
//
//  Created by Trung Vo on 19/08/2024.
//

import SwiftUI

extension LinearGradient {
    static func mainGradientBlueOnly(blueOpacity: Double = 0.6,
                                     startPoint: UnitPoint = .topLeading,
                                     endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        LinearGradient(colors: [
            Color.mainBlue,
            Color.mainBlue.opacity(blueOpacity)
        ], startPoint: startPoint, endPoint: endPoint)
    }
    
    static func mainGradientWithPurple(purpleOpacity: Double = 0.8,
                             startPoint: UnitPoint = .topLeading,
                             endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        LinearGradient(colors: [
            Color.mainBlue,
            Color.mainPurple.opacity(purpleOpacity)
        ], startPoint: startPoint, endPoint: endPoint)
    }
}
