//
//  ToastMessage.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import UIKit

class ToastMessageView: UIView {
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
    
    required init?(coder: NSCoder) { nil }
    
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
    #if DEBUG
    static var dismissAutomatically = true
    #endif
    
    @MainActor
    static func showError(message: String, on parent: UIView, duration: TimeInterval = 2) async {        
        let view = ToastMessageView()
        view.message = message
        view.type = .error
        
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
        parent.layoutIfNeeded()
        
        let openConstraint = view.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor)
        let closeConstraint = view.bottomAnchor.constraint(equalTo: parent.topAnchor)
        
        openConstraint.isActive = false
        closeConstraint.isActive = true
        parent.layoutIfNeeded()
        
        await UIView.animate(withDuration: 0.3) {
            openConstraint.isActive = true
            closeConstraint.isActive = false
            parent.layoutIfNeeded()
        }
        
        #if DEBUG
        guard dismissAutomatically else { return }
        #endif
        
        try? await Task.sleep(seconds: duration)
        
        await UIView.animate(withDuration: 0.3) {
            openConstraint.isActive = false
            closeConstraint.isActive = true
            parent.layoutIfNeeded()
        }
        
        view.removeFromSuperview()
    }
}

extension UIView {
    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) async {
        await withCheckedContinuation({ continuation in
            animate(withDuration: duration, animations: animations) { _ in
                continuation.resume()
            }
        })
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
