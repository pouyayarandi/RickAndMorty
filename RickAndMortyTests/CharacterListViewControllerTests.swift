//
//  CharacterListViewControllerTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import XCTest
import Combine
import SnapshotTesting
@testable import RickAndMorty

class MockImageCache: ImageCacheProtocol {
    func getImage(for url: URL) -> UIImage? {
        UIImage(named: "TestImage", in: .test, compatibleWith: nil)
    }
    
    func storeImage(_ image: UIImage, for url: URL) {}
    func reset() {}
}

class MockCharacterListViewModel: CharacterListViewModelProtocol {
    @Published var _items: [CharacterResponse] = []
    var items: Output<[CharacterResponse]> {
        (_items, $_items.eraseToAnyPublisher())
    }
    
    var error: AnyPublisher<String, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        _items = data.results
    }
    
    func viewDidRequestForNextPage() {}
}

class CharacterListViewControllerTests: XCTestCase {
    var sut: CharacterListViewController!
    
    func testLoadCharacterListView() async {
        await MainActor.run {
            sut = CharacterListViewController(viewModel: MockCharacterListViewModel())
            sut.imageCache = MockImageCache()
            sut.loadViewIfNeeded()
        }
        
        var lightTrait: UITraitCollection {
            .init(traitsFrom: [
                .init(displayScale: 1),
                .init(userInterfaceStyle: .light)
            ])
        }
        
        var darkTrait: UITraitCollection {
            .init(traitsFrom: [
                .init(displayScale: 1),
                .init(userInterfaceStyle: .dark)
            ])
        }
        
        await MainActor.run {
            assertSnapshot(matching: sut, as: .image(on: .iPhone8, size: .init(width: 375, height: 667), traits: lightTrait))
            assertSnapshot(matching: sut, as: .image(on: .iPhone8, size: .init(width: 375, height: 667), traits: darkTrait))
        }
    }
}
