//
//  AppCoordinator.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
    
    let window: UIWindow?
        
    // Since AppCoordinator is top of all coordinators of our app, it has no parent and is nil.
    weak var parentCoordinator: Coordinator?
    
    // ChildCoordinators of AppCoordinator
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
        super.init()
        navigationController.delegate = self
    }
    
    private weak var reloadApartments: ReloadApartments?
    
    // Start of the app
    func start(animated: Bool) {
        guard let window = window else { return }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let apartmentsViewController = ApartmentsViewController.instantiate(coordinator: self)
        reloadApartments = apartmentsViewController
        navigationController.pushViewController(apartmentsViewController, animated: true)
    }
    
    func reloadList() {
        reloadApartments?.reloadApartments()
    }
    
    func navigateToMap(_ apartment: Apartment) {
        let mapViewController = MapViewController.instantiate(coordinator: self)
        mapViewController.mapViewModel.apartment = apartment
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
    }
}
