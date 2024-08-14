//
//  MainViewCoordinator.swift
//  ColorNote
//
//  Created by Trung Vo on 29/05/2024.
//

import UIKit
import SwiftUI

// MARK: - MainViewCoordinator
final class MainViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let tabBarView = TabBarView().environment(\.managedObjectContext, context)
        let viewController = UIHostingController(rootView: tabBarView)
        navigationController?.viewControllers = [viewController]
    }
}


