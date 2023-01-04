//
//  LoadableImageView.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/11/22.
//

import UIKit

class LoadableImageView: UIImageView {
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = .clear
        spinner.color = .lightGray
        return spinner
    }()
    
    init() {
        super.init(frame: .zero)
        self.insertSubview(self.spinner, at: 0)
        self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }
    
}
