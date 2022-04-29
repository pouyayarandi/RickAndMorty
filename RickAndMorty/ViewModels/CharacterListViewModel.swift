//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Pouya on 11/13/1400 AP.
//

import Foundation
import Combine

protocol CharacterListViewModelProtocol: AnyObject {
    var items: CurrentValueSubject<[CharacterResponse], Never> { get }
    
    func viewDidLoad()
    func viewDidRequestForNextPage()
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    var items: CurrentValueSubject<[CharacterResponse], Never> = .init([])
    
    var repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.getCharactersFirstPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.items.send(data.results)
            case .failure(let error):
                ToastMessage.showError(message: error.localizedDescription)
            }
        }
    }
    
    func viewDidRequestForNextPage() {
        repository.getCharactersNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                var items = self.items.value
                items.append(contentsOf: data.results)
                self.items.send(items)
            case .failure(let error):
                ToastMessage.showError(message: error.localizedDescription)
            }
        }
    }
}
