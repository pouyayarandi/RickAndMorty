//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window!, networkLayer: NetworkLayer(session: .shared))
        _ = appCoordinator?.start()
        return true
    }

}

