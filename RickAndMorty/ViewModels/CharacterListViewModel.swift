//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Pouya on 11/13/1400 AP.
//

import Foundation
import Combine

protocol CharacterListViewModelProtocol: AnyObject {
    var items: Output<[CharacterResponse]> { get }
    var error: AnyPublisher<String, Never> { get }
    func viewDidLoad() async
    func viewDidRequestForNextPage() async
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    
    @Published private var _items: [CharacterResponse] = []
    private var _error: PassthroughSubject<String, Never> = .init()
    private var repository: CharacterRepositoryProtocol
    
    var items: Output<[CharacterResponse]> {
        (_items, $_items.eraseToAnyPublisher())
    }
    
    var error: AnyPublisher<String, Never> {
        _error.eraseToAnyPublisher()
    }
    
    init?(container: IoCContainer) {
        guard let repository = container.resolve(CharacterRepositoryProtocol.self) else {
            return nil
        }
        
        self.repository = repository
    }
    
    func viewDidLoad() async {
        await self.getFirstPage()
    }
    
    func viewDidRequestForNextPage() async {
        await self.getNextPage()
    }
    
    private func getFirstPage() async {
        do {
            let data = try await repository.getCharactersFirstPage()
            _items = data.results
        } catch {
            _error.send(error.localizedDescription)
        }
    }
    
    private func getNextPage() async {
        do {
            let data = try await repository.getCharactersNextPage()
            _items.append(contentsOf: data?.results ?? [])
        } catch {
            _error.send(error.localizedDescription)
        }
    }
}
