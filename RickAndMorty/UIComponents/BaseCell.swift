//
//  BaseCell.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import UIKit

protocol Cell {
    var contentView: UIView { get }
}

extension UICollectionViewCell: Cell {}
extension UITableViewCell: Cell {}

protocol StackHolderCell: AnyObject {
    var stackHolder: UIStackView { get }
}

extension StackHolderCell where Self: Cell {
    func setupStackHolder() {
        contentView.addSubview(stackHolder)
        stackHolder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackHolder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackHolder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackHolder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

class BaseCollectionCell: UICollectionViewCell, StackHolderCell {
    final var stackHolder = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupStackHolder()
    }
}

class BaseTableCell: UITableViewCell, StackHolderCell {
    final var stackHolder = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupStackHolder()
    }
}
