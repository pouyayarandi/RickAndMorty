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
    var expectation = XCTestExpectation()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ImageView()
    }

    func testImageViewLoadURLImage() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockProtocol<ImageResponse>.self]

        sut.imageAsset = URLImageAsset(.init(string: "https://example.com/image.png")!, session: .init(configuration: config))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            XCTAssertEqual(self.sut.image?.pngData(), ImageResponse.responseData)
            self.expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
