//
//  BusinessListTableViewCell.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/11/22.
//

import UIKit
import Combine

class BusinessListTableViewCell: UITableViewCell {

    static let reuseID = "\(BusinessListTableViewCell.self)"
    
    lazy var businessImageView: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Top Text"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Bottom Text"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        let vStackInner = UIStackView(frame: .zero)
        vStackInner.translatesAutoresizingMaskIntoConstraints = false
        vStackInner.axis = .vertical
        vStackInner.spacing = 2
        
        let topBufferInner = UIView.generateBufferView()
        let bottomBufferInner = UIView.generateBufferView()
        
        vStackInner.addArrangedSubview(topBufferInner)
        vStackInner.addArrangedSubview(self.topLabel)
        vStackInner.addArrangedSubview(self.bottomLabel)
        vStackInner.addArrangedSubview(bottomBufferInner)
        
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        hStack.addArrangedSubview(self.businessImageView)
        hStack.addArrangedSubview(vStackInner)
        
        let vStackOuter = UIStackView(frame: .zero)
        vStackOuter.translatesAutoresizingMaskIntoConstraints = false
        vStackOuter.axis = .vertical

        let topBufferOuter = UIView.generateBufferView()
        let bottomBufferOuter = UIView.generateBufferView()
        
        vStackOuter.addArrangedSubview(topBufferOuter)
        vStackOuter.addArrangedSubview(hStack)
        vStackOuter.addArrangedSubview(bottomBufferOuter)
        
        self.contentView.addSubview(vStackOuter)
        vStackOuter.bindToSuperView()
        
        topBufferInner.heightAnchor.constraint(equalTo: bottomBufferInner.heightAnchor).isActive = true
        topBufferOuter.heightAnchor.constraint(equalTo: bottomBufferOuter.heightAnchor).isActive = true
    }
    
    var businessViewModel: BusinessViewModel?
    var subs = Set<AnyCancellable>()
    
    func configure(businessViewModel: BusinessViewModel) {
        self.businessViewModel = businessViewModel
        
        self.topLabel.text = "\(businessViewModel.name) : \(businessViewModel.price)"
        self.bottomLabel.text = "\(businessViewModel.rating) : \(businessViewModel.distance)"
        
        businessViewModel.$imageData
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.businessImageView.stop()
                if businessViewModel === self?.businessViewModel {
                    self?.businessImageView.image = UIImage(data: data)
                }
            }.store(in: &self.subs)
        
        self.businessImageView.start()
        DispatchQueue.global().asyncAfter(deadline: .now() + DebugSettings.shared.intervalThrottleTime) {
            businessViewModel.getImageData()
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.topLabel.text = nil
        self.bottomLabel.text = nil
        self.businessImageView.image = nil
    }

}
