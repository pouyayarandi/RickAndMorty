//
//  BaseTabBarController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class BaseTabBarController: UITabBarController {
    var coordinators: [Coordinator] = []
    
    func setCoordinators(_ coordinators: [Coordinator], animated: Bool) {
        self.coordinators = coordinators
        setViewControllers(coordinators.map({ $0.start() }), animated: animated)
    }
}
