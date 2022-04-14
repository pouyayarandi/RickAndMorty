//
//  CharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class CharacterCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    private var container: IoCContainer
    private var network: NetworkProtocol
    private var characterRepository: CharacterRepositoryProtocol
    
    init(container: IoCContainer) {
        self.container = container
        network = container.container.resolve(NetworkProtocol.self)!
        characterRepository = CharacterRepository(network: network)
    }
    
    func start() -> UIViewController {
        let vc = CharacterListViewController()
        vc.viewModel = CharacterListViewModel(output: .init(), repository: characterRepository)
        vc.imageCache = MemoryImageCache.shared
        let nv = UINavigationController.init(rootViewController: vc)
        self.navigationController = nv
        return nv
    }
}
