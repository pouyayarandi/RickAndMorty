//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import Swinject

protocol IoCContainer {
    func registerServices()
    func resolve<T>(_ type: T.Type) -> T?
}

class AppContainer: IoCContainer {
    var container: Container = .init()
    
    func registerServices() {
        container.register(NetworkProtocol.self) { _ in
            NetworkLayer(session: .shared)
        }

        container.register(CharacterRepositoryProtocol.self) { resolver in
            CharacterRepository(network: resolver.resolve(NetworkProtocol.self)!)
        }

        container.register(LocationRepositoryProtocol.self) { resolver in
            LocationRepository(network: resolver.resolve(NetworkProtocol.self)!)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }
}
