//
//  CharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class CharacterCoordinator: Coordinator {
    var navigationController: UINavigationController?
    private var characterRepository: CharacterRepositoryProtocol
    
    init(networkLayer: NetworkProtocol) {
        characterRepository = CharacterRepository(network: networkLayer)
    }
    
    func start() -> UIViewController {
        let vc = CharacterListViewController()
        vc.viewModel = CharacterListViewModel(repository: characterRepository)
        vc.imageCache = MemoryImageCache.shared
        let nv = UINavigationController.init(rootViewController: vc)
        self.navigationController = nv
        return nv
    }
}
