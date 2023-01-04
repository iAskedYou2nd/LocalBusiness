//
//  BusinessCategoryHeaderView.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/31/22.
//

import UIKit

class BusinessCategoryHeaderView: UITableViewHeaderFooterView {
    
    enum Categories: String, CaseIterable {
        typealias Colors = (primary: UIColor, secondary: UIColor)
        
        case mexican = "Mexican"
        case italian = "Italian"
        case american = "American"
        case chinese = "Chinese"
        case latin = "Latin"
        
        var colors: Colors {
            switch self {
            case .american:
                return (primary: .systemOrange, secondary: .white)
            case .chinese:
                return (primary: .systemRed, secondary: .white)
            case .italian:
                return (primary: .systemBlue, secondary: .white)
            case .mexican:
                return (primary: .systemPurple, secondary: .white)
            case .latin:
                return (primary: .systemYellow, secondary: .black)
            }
        }
    }
    
    
    static let reuseID = "\(BusinessCategoryHeaderView.self)"
    
    lazy var categoryCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 42)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(BusinessCategoryCollectionViewCell.self, forCellWithReuseIdentifier: BusinessCategoryCollectionViewCell.reuseID)
        return collection
    }()
    
    var categories: [Categories] = Categories.allCases
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.categoryCollection)
        self.categoryCollection.bindToSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BusinessCategoryHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCategoryCollectionViewCell.reuseID, for: indexPath) as? BusinessCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(category: Categories.allCases[indexPath.item])
    
        return cell
    }
    
}

extension BusinessCategoryHeaderView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}
