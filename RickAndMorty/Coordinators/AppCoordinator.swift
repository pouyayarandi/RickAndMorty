//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    private var window: UIWindow
    private var container: IoCContainer
    private var network: NetworkProtocol
    
    init(window: UIWindow, container: IoCContainer) {
        self.window = window
        self.container = container
        network = container.container.resolve(NetworkProtocol.self)!
    }
    
    func start() -> UIViewController {
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        let charactersFlow = CharacterCoordinator(container: container)
        vc.setCoordinators([charactersFlow], animated: false)
        
        vc.setTabBar(index: 0, with: .character)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        return vc
    }
}
