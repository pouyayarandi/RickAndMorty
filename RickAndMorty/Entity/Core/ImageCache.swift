//
//  ImageCache.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import UIKit

extension URL {
    var asNSURL: NSURL? {
        NSURL(string: absoluteString)
    }
}

protocol ImageCacheProtocol: AnyObject {
    func getImage(for url: URL) -> UIImage?
    func storeImage(_ image: UIImage, for url: URL)
    func reset()
}

class MemoryImageCache: ImageCacheProtocol {
    static let shared = MemoryImageCache()
    private var cache: NSCache<NSURL, UIImage> = .init()
    
    func getImage(for url: URL) -> UIImage? {
        guard let key = url.asNSURL else { return nil }
        return cache.object(forKey: key)
    }
    
    func storeImage(_ image: UIImage, for url: URL) {
        guard let key = url.asNSURL else { return }
        cache.setObject(image, forKey: key)
    }
    
    func reset() {
        cache.removeAllObjects()
    }
}
