//
//  FileHelper.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

extension Bundle {
    static var test: Bundle {
        Bundle(for: FileHelper.self)
    }
}

class FileHelper {
    static func objectFromFile<T: Decodable>(_ fileName: String) -> T {
        let data = try! Data(contentsOf: Bundle.test.url(forResource: fileName, withExtension: "json")!)
        return try! JSONDecoder().decode(T.self, from: data)
    }
}
