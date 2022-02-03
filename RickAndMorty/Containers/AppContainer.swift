//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import Swinject

protocol IoCContainer {
    var container: Container { get }
    func register()
}

class AppContainer: IoCContainer {
    var container: Container = .init()
    
    func register() {
        container.register(NetworkProtocol.self) { _ in
            NetworkLayer(session: .shared)
        }
    }
}
