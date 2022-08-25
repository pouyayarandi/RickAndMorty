//
//  ImageAsset.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation
import UIKit

struct Image {
    var name: String
}

protocol ImageAsset {
    func loadImage(_ completionHandler: @escaping (UIImage?) -> Void)
    func unloadImage(_ imageView: UIImageView)
}

class URLImageAsset: ImageAsset {
    var url: URL?
    var session: URLSession
    var cache: ImageCacheProtocol?
    
    private var task: URLSessionDataTask?
    
    init(_ url: URL?, session: URLSession = .shared, cache: ImageCacheProtocol? = nil) {
        self.url = url
        self.session = session
        self.cache = cache
    }
    
    func loadImage(_ completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completionHandler(nil)
            return
        }

        if let image = cache?.getImage(for: url) {
            completionHandler(image)
            return
        }
        
        task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            guard let image = UIImage(data: data) else {
                completionHandler(nil)
                return
            }
            self.cache?.storeImage(image, for: url)
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
        
        task?.resume()
    }
    
    func unloadImage(_ imageView: UIImageView) {
        task?.cancel()
        imageView.image = nil
    }
}
