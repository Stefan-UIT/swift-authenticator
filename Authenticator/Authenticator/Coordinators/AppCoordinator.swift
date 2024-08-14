//
//  AppCoordinator.swift
//  ColorNote
//
//  Created by Trung Vo on 29/05/2024.
//

import UIKit
import SwiftUI

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController()
        navigationController?.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
        coordinateToMain()
    }
}

private extension AppCoordinator {
    func coordinateToMain() {
        guard let navigationController = navigationController else { return }
        let coordinator = MainViewCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}

// MARK: - Shared
extension AppCoordinator {
    static let share = SceneDelegate.share?.coordinator as? AppCoordinator
    
    var currentWindow: UIWindow? {
        UIWindow.key
    }
    
    var visibleViewController: UIViewController? {
        var currentVc = currentWindow?.rootViewController
        while let presentedVc = currentVc?.presentedViewController {
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        return currentVc
    }
}
