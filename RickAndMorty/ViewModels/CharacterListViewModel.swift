//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Pouya on 11/13/1400 AP.
//

import Foundation
import Combine

class CharacterListViewOutput {
    @Published var items: [CharacterResponse] = []
    var error: PassthroughSubject<String, Never> = .init()
}

protocol CharacterListViewModelProtocol: AnyObject {
    var output: CharacterListViewOutput { get }
    
    func viewDidLoad()
    func viewDidRequestForNextPage()
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    var output: CharacterListViewOutput
    var repository: CharacterRepositoryProtocol
    
    init(output: CharacterListViewOutput, repository: CharacterRepositoryProtocol) {
        self.output = output
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.getCharactersFirstPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.output.items = data.results
            case .failure(let error):
                self?.output.error.send(error.localizedDescription)
            }
        }
    }
    
    func viewDidRequestForNextPage() {
        repository.getCharactersNextPage { [weak self] result in
            switch result {
            case .success(let data):
                self?.output.items.append(contentsOf: data.results)
            case .failure(let error):
                self?.output.error.send(error.localizedDescription)
            }
        }
    }
}
