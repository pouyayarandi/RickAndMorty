//
//  CharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class CharacterCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    private var container: IoCContainer
    weak private var parent: MainViewController?
    
    init(container: IoCContainer, parent: MainViewController) {
        self.container = container
        self.parent = parent
    }
    
    func start() {
        guard let vm = CharacterListViewModel(container: container) else { return }

        let vc = CharacterListViewController(viewModel: vm)
        vc.imageCache = MemoryImageCache.shared
        let nv = UINavigationController(rootViewController: vc)
        self.navigationController = nv
        
        parent?.appendViewController(nv, animated: false)
    }
}
