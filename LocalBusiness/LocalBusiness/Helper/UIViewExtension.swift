//
//  UIViewExtension.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/5/22.
//

import UIKit

extension UIView {
    
    func bindToSuperView(with insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        guard let superSafeArea = self.superview?.safeAreaLayoutGuide else {
            fatalError("Whoops, you forgot to add the view to the view hierarchy, double check your work.")
        }
        
        self.topAnchor.constraint(equalTo: superSafeArea.topAnchor, constant: insets.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superSafeArea.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superSafeArea.trailingAnchor, constant: -insets.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superSafeArea.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    static func generateBufferView() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.backgroundColor = .clear
        return view
    }
    
}
