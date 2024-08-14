//
//  UIOnboardingHelper.swift
//  SwapUni
//
//  Created by Trung Vo on 04/03/2024.
//

import UIKit
import UIOnboarding

struct UIOnboardingHelper {
    static func setUpIcon() -> UIImage {
        return Bundle.main.appIcon ?? .init(named: "app-icon-512px")!
    }
    
    // First Title Line
    // Welcome Text
    static func setUpFirstTitleLine() -> NSMutableAttributedString {
        .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
    }
    
    // Second Title Line
    // App Name
    static func setUpSecondTitleLine() -> NSMutableAttributedString {
        .init(string: Bundle.main.displayName ?? "Authenticator", attributes: [
            .foregroundColor: UIColor.mainBlue
        ])
    }

    static func setUpFeatures() -> Array<UIOnboardingFeature> {
        return .init([
            .init(icon: .init(named: "feature-1")!,
                  title: "Secure Your Accounts 🔐",
                  description: "Easily add your accounts by scanning QR codes. Keep your 2FA codes safe and accessible."),
            .init(icon: .init(named: "feature-2")!,
                  title: "Sync with iCloud ☁️",
                  description: "Enable iCloud sync to back up your 2FA codes securely. Access them across all your Apple devices effortlessly."),
            .init(icon: .init(named: "feature-3")!,
                  title: "Import & Export 🚀",
                  description: "Easily import or export your 2FA codes to keep your accounts secure, even when switching devices."),
        ])
    }
    
    static func setUpNotice() -> UIOnboardingTextViewConfiguration {
//        return .init(icon: .init(named: "onboarding-notice-icon"),
//                     text: "Developed and designed for members of the Swiss Armed Forces.",
//                     linkTitle: "Learn more...",
//                     link: "https://www.lukmanascic.ch/portfolio/insignia",
//                     tint: .init(named: "camou") ?? .init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0))
        .init(text: "")
    }
    
    static func setUpButton() -> UIOnboardingButtonConfiguration {
        return .init(title: "Get Started",
                     backgroundColor: .mainBlue)
    }
}

extension UIOnboardingViewConfiguration {
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                     features: UIOnboardingHelper.setUpFeatures(),
                     textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                     buttonConfiguration: UIOnboardingHelper.setUpButton())
    }
}
