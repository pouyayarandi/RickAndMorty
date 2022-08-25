//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var window: UIWindow
    private var container: IoCContainer
    
    init(window: UIWindow, container: IoCContainer) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let vc = MainViewController()
        
        let tabCoordinators: [Coordinator] = [
            CharacterCoordinator(container: container, parent: vc),
            LocationCoordinator(container: container, parent: vc)
        ]
        
        for coordinator in tabCoordinators {
            childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
            coordinator.start()
        }
        
        vc.setTabBar(index: 0, with: .character)
        vc.setTabBar(index: 1, with: .location)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
