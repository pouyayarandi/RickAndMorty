//
//  Coordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start() -> UIViewController
}
