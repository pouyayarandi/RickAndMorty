//
//  ImageView.swift
//  RickAndMorty
//
//  Created by Pouya on 11/13/1400 AP.
//

import UIKit

class ImageView: UIImageView {
    var imageAsset: ImageAsset? {
        willSet {
            imageAsset?.unloadImage(self)
        }
        didSet {
            imageAsset?.loadImage { [weak self] image in
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
