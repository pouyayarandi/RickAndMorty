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
    var appContainer: AppContainer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        appContainer = AppContainer()
        appContainer?.registerServices()
        
        appCoordinator = AppCoordinator(window: window, container: appContainer!)
        appCoordinator?.start()
        
        return true
    }

}
