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
    var output: CharacterListOutput = .init()
    
    func viewDidLoad() {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        output.items = data.results
    }
    
    func viewDidRequestForNextPage() {}
}

class CharacterListViewControllerTests: XCTestCase {
    var sut: CharacterListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = CharacterListViewController(viewModel: MockCharacterListViewModel())
        sut.imageCache = MockImageCache()
    }
    
    func testLoadCharacterListView() async {
        await MainActor.run {
            sut.loadViewIfNeeded()
        }
        
        await MainActor.run {
            assertSnapshot(matching: self.sut, as: .image(on: .iPhone8, traits: .init(userInterfaceStyle: .light)))
            assertSnapshot(matching: self.sut, as: .image(on: .iPhone8, traits: .init(userInterfaceStyle: .dark)))
        }
    }
}
