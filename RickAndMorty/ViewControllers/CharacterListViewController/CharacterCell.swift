//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
import UIKit

class CharacterCell: BaseCell {
    private var avatarView = ImageView()
    private var titleLabel = UILabel()
    private var statusLabel = UILabel()
    
    var avatar: ImageAsset? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    var title: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    var status: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.imageAsset = avatar
        titleLabel.text = title
        statusLabel.text = status
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.imageAsset = nil
    }
    
    override func setup() {
        super.setup()
        
        stackHolder.distribution = .fill
        stackHolder.alignment = .center
        stackHolder.axis = .horizontal
        stackHolder.spacing = 16
        
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor).isActive = true
        stackHolder.addArrangedSubview(avatarView)
        
        let containerStack = UIStackView()
        containerStack.distribution = .fill
        containerStack.axis = .vertical
        containerStack.spacing = 8
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        stackHolder.addArrangedSubview(containerStack)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        containerStack.addArrangedSubview(titleLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        statusLabel.textColor = .secondaryLabel
        containerStack.addArrangedSubview(statusLabel)
    }
}
