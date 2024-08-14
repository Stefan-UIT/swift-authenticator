//
//  CoordinatorProtocols.swift
//  ColorNote
//
//  Created by Trung Vo on 29/05/2024.
//

import UIKit

protocol Coordinator: AnyObject, Coordinatable, Navigable {}

protocol Coordinatable {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinatable {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}

protocol Navigable {
    var navigationController: UINavigationController? { get set }
    
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool)
    func presentViewController(_ viewController: UIViewController,
                               animated: Bool,
                               completion: (() -> Void)?)
    func popViewController(animated: Bool)
    @discardableResult
    func pop<Controller: UIViewController>(toViewController viewController: Controller.Type,
                                           animated: Bool) -> Bool
}

extension Navigable {
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func presentViewController(_ viewController: UIViewController,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) {
        navigationController?.present(viewController,
                                      animated: animated,
                                      completion: completion)
    }

    func pop<Controller: UIViewController>(toViewController viewController: Controller.Type,
                                           animated: Bool = true) -> Bool {
        guard let navigationController = navigationController,
              let foundVC = find(viewController: viewController)
        else { return false }
        navigationController.popToViewController(foundVC,
                                                 animated: animated)
        return true
    }
    
    func find<Controller: UIViewController>(viewController: Controller.Type) -> Controller? {
        guard let navigationController = navigationController
        else { return nil }
        for controller in navigationController.viewControllers {
                if controller.isKind(of: viewController) {
                    return controller as? Controller
                }
        }
        return nil
    }
}
