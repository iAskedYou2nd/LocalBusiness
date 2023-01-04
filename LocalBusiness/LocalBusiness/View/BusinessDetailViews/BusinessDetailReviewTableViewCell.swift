//
//  BusinessDetailReviewTableViewCell.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 12/2/22.
//

import UIKit
import Combine

class BusinessDetailReviewTableViewCell: UITableViewCell {

    static let reuseID = "\(BusinessDetailReviewTableViewCell.self)"
    
    lazy var userImageView: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
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
    
    var subs = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 2
        
        hStack.addArrangedSubview(self.userImageView)
        hStack.addArrangedSubview(self.topLabel)
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 2
        
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(self.bottomLabel)
        
        self.contentView.addSubview(vStack)
        vStack.bindToSuperView()
    }
    
    func configure(reviewViewModel: ReviewViewModel) {
        self.topLabel.text = "\(reviewViewModel.name) - \(reviewViewModel.rating) - \(reviewViewModel.date)"
        self.bottomLabel.text = reviewViewModel.text
        self.userImageView.image = UIImage(named: "question-mark")
        
        reviewViewModel.$imageData
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.userImageView.image = UIImage(data: data)
            }.store(in: &self.subs)
        
        reviewViewModel.getImageData()
    }
    

}
