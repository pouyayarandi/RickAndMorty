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
    private var networkLayer: NetworkProtocol
    
    init(window: UIWindow, networkLayer: NetworkProtocol) {
        self.window = window
        self.networkLayer = networkLayer
    }
    
    func start() -> UIViewController {
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        let charactersFlow = CharacterCoordinator(networkLayer: networkLayer)
        vc.setCoordinators([charactersFlow], animated: false)
        
        vc.setTabBar(index: 0, with: .character)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        return vc
    }
}
