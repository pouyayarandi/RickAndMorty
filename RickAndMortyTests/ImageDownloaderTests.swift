//
//  ImageDownloaderTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation
import XCTest
@testable import RickAndMorty

struct ImageResponse: Response {
    static var statusCode: Int { 200 }
    static var responseData: Data { UIImage(named: "TestImage", in: .test, with: nil)!.pngData()! }
}

class ImageViewTests: XCTestCase {

    var sut: ImageView!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ImageView()
        expectation = .init()
    }

    override func tearDownWithError() throws {
        sut = nil
        expectation = nil
        try super.tearDownWithError()
    }

    func testImageViewLoadURLImage() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol<ImageResponse>.self]

        sut.imageAsset = URLImageAsset(.init(string: "https://example.com/image.png")!, session: .init(configuration: config))
        
        let observation = sut.publisher(for: \.image).compactMap({ $0 }).sink { image in
            XCTAssertEqual(image?.pngData(), ImageResponse.responseData)
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        observation.cancel()
    }
}
