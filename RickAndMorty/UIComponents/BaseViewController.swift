//
//  BaseViewController.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    final var bag = Set<AnyCancellable>()
    final var stackHolder = UIStackView()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(stackHolder)
        stackHolder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        self.view = view
    }
    
    final func showMessage(for message: String) {
        Task {
            await ToastMessage.showError(message: message, on: view)
        }
    }
}
