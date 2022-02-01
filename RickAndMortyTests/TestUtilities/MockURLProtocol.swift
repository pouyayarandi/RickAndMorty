//
//  MockURLProtocol.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol Response {
    static var statusCode: Int { get }
    static var responseData: Data { get }
}

class MockProtocol<R: Response>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    override func startLoading() {
        client?.urlProtocol(self, didLoad: R.responseData)
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: R.statusCode, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
}
