//
//  BusinessCategoryCollectionViewCell.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 11/9/22.
//

import UIKit

class BusinessCategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "\(BusinessCategoryCollectionViewCell.self)"
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PlaceHolder"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.categoryLabel)
        self.categoryLabel.bindToSuperView()
        self.contentView.backgroundColor = .systemCyan
        self.contentView.layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(category: BusinessCategoryHeaderView.Categories) {
        self.contentView.backgroundColor = category.colors.primary
        self.categoryLabel.textColor = category.colors.secondary
        self.categoryLabel.text = category.rawValue
    }
    
}
