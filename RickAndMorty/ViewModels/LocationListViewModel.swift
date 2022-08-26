//
//  LocationListViewModel.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import Combine

protocol LocationListViewModelProtocol: AnyObject {
    var items: CurrentValueSubject<[LocationResponse], Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    
    func viewDidLoad()
    func viewDidRequestForNextPage()
}

class LocationListViewModel: LocationListViewModelProtocol {
    var items: CurrentValueSubject<[LocationResponse], Never> = .init([])
    var error: PassthroughSubject<String, Never> = .init()
    
    var repository: LocationRepositoryProtocol
    
    init?(container: IoCContainer) {
        guard let repository = container.resolve(LocationRepositoryProtocol.self) else {
            return nil
        }
        
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.getLocationsFirstPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.items.send(data.results)
            case .failure(let error):
                self?.error.send(error.localizedDescription)
            }
        }
    }
    
    func viewDidRequestForNextPage() {
        repository.getLocationsNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                var items = self.items.value
                items.append(contentsOf: data.results)
                self.items.send(items)
            case .failure(let error):
                self.error.send(error.localizedDescription)
            }
        }
    }
}
