//
//  LocationCoordinator.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class LocationCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    private var container: IoCContainer
    private var network: NetworkProtocol
    private var locationRepository: LocationRepositoryProtocol
    
    init(container: IoCContainer) {
        self.container = container
        network = container.container.resolve(NetworkProtocol.self)!
        locationRepository = LocationRepository(network: network)
    }
    
    func start() -> UIViewController {
        let vc = LocationListViewController()
        vc.viewModel = LocationListViewModel(repository: locationRepository)
        let nv = UINavigationController.init(rootViewController: vc)
        self.navigationController = nv
        return nv
    }
}
