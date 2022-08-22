//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Pouya on 11/13/1400 AP.
//

import Foundation
import Combine

class CharacterListOutput {
    @Published var items: [CharacterResponse] = []
}

protocol CharacterListViewModelProtocol: AnyObject {
    var output: CharacterListOutput { get set }
    
    func viewDidLoad() async
    func viewDidRequestForNextPage() async
}

class CharacterListViewModel: CharacterListViewModelProtocol {
    var output: CharacterListOutput = .init()
    var repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol) {
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
            output.items = data.results
        } catch let error as NetworkError {
            ToastMessage.showError(message: error.localizedDescription)
        } catch {}
    }
    
    private func getNextPage() async {
        do {
            let data = try await repository.getCharactersNextPage()
            output.items.append(contentsOf: data?.results ?? [])
        } catch let error as NetworkError {
            ToastMessage.showError(message: error.localizedDescription)
        } catch {}
    }
}
