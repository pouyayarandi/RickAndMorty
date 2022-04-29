//
//  GenericCell.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class GenericCell: BaseCell {
    
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    var title: String? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var subtitle: String? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    override func setup() {
        super.setup()
        
        stackHolder.axis = .vertical
        stackHolder.distribution = .fill
        stackHolder.spacing = 8
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        stackHolder.addArrangedSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        stackHolder.addArrangedSubview(subtitleLabel)
    }
}
