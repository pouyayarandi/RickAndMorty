//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import UIKit

class MainViewController: BaseTabBarController {
    enum Tab {
        case character
        case location
        
        var title: String {
            switch self {
            case .character: return "Characters"
            case .location: return "Locations"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .character: return .init(systemName: "person.crop.circle.fill")
            case .location: return .init(systemName: "location.circle.fill")
            }
        }
    }
    
    func setTabBar(index: Int, with tab: Tab) {
        guard 0 ..< (tabBar.items?.count ?? 0) ~= index else { return }
        tabBar.items?[index].title = tab.title
        tabBar.items?[index].image = tab.image
        tabBar.items?[index].selectedImage = tab.image
    }
}
