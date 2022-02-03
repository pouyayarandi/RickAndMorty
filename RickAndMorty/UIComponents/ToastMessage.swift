//
//  ToastMessage.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

fileprivate class ToastMessageView: UIView {
    private var messageLabel = UILabel()
    
    enum MessageType {
        case error
        
        var color: UIColor {
            switch self {
            case .error: return .systemRed
            }
        }
    }
    
    var message: String? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var type: MessageType = .error {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(messageLabel)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = type.color
        messageLabel.text = message
    }
}

class ToastMessage {
    static func showError(message: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window?.flatMap({ $0 }) else { return }
            
            let view = ToastMessageView()
            view.message = message
            view.type = .error
            
            window.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: window.trailingAnchor)
            ])
            window.layoutIfNeeded()
            
            let openConstraint = view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor)
            let closeConstraint = view.bottomAnchor.constraint(equalTo: window.topAnchor)
            
            openConstraint.isActive = false
            closeConstraint.isActive = true
            window.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3) {
                openConstraint.isActive = true
                closeConstraint.isActive = false
                window.layoutIfNeeded()
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    UIView.animate(withDuration: 0.3) {
                        openConstraint.isActive = false
                        closeConstraint.isActive = true
                        window.layoutIfNeeded()
                    } completion: { _ in
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }
}
