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
    
    func viewDidLoad()
    func viewDidRequestForNextPage()
}

class LocationListViewModel: LocationListViewModelProtocol {
    var items: CurrentValueSubject<[LocationResponse], Never> = .init([])
    
    var repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.getLocationsFirstPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.items.send(data.results)
            case .failure(_):
                break
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
            case .failure(_):
                break
            }
        }
    }
}
