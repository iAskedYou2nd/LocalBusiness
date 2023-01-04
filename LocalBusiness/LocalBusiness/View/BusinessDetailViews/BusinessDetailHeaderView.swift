//
//  BusinessDetailHeaderView.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 12/2/22.
//

import UIKit
import Combine

class BusinessDetailHeaderView: UITableViewHeaderFooterView {

    static let reuseID = "\(BusinessDetailHeaderView.self)"
    
    lazy var businessImageView: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "address"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Rating"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var subs = Set<AnyCancellable>()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        
        let topBuffer = UIView.generateBufferView()
        let bottomBuffer = UIView.generateBufferView()
        
        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.nameLabel)
        vStack.addArrangedSubview(self.addressLabel)
        vStack.addArrangedSubview(self.numberLabel)
        vStack.addArrangedSubview(self.ratingLabel)
        vStack.addArrangedSubview(bottomBuffer)
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        hStack.addArrangedSubview(self.businessImageView)
        hStack.addArrangedSubview(vStack)
        
        self.contentView.addSubview(hStack)
        hStack.bindToSuperView()
    }
    
    func configure(viewModel: BusinessViewModel) {
        self.nameLabel.text = viewModel.name
        self.addressLabel.text = viewModel.address
        self.numberLabel.text = viewModel.phoneNumber
        self.ratingLabel.text = viewModel.rating

        self.businessImageView.start()
        viewModel.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.businessImageView.stop()
                self?.businessImageView.image = UIImage(data: data)
            }.store(in: &self.subs)
        
        
    }
    
}
