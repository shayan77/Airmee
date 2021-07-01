//
//  Coordinator.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? {get set}
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start(animated: Bool)
    func finish()
}

extension Coordinator {
    
    func start() {
        start(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func finish() {}
}
