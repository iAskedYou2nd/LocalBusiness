//
//  BusinessDetailViewController.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/5/22.
//

import UIKit
import Combine

class BusinessDetailViewController: UIViewController {

    lazy var businessTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(BusinessDetailReviewTableViewCell.self, forCellReuseIdentifier: BusinessDetailReviewTableViewCell.reuseID)
        table.register(BusinessDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: BusinessDetailHeaderView.reuseID)
        
        return table
    }()
    
    private var subs = Set<AnyCancellable>()
    let businessViewModel: BusinessViewModel
    let reviewListViewModel: ReviewListViewModel
    
    init(businessViewModel: BusinessViewModel) {
        self.businessViewModel = businessViewModel
        self.reviewListViewModel = ReviewListViewModel(id: businessViewModel.id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
        
        self.reviewListViewModel.$reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.businessTableView.reloadData()
            }.store(in: &self.subs)

        self.reviewListViewModel.fetchReviews()
    }
    
    private func buildUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.businessTableView)
        self.businessTableView.bindToSuperView()
    }
    
}

extension BusinessDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BusinessDetailHeaderView.reuseID) as? BusinessDetailHeaderView else { return nil }

        header.configure(viewModel: self.businessViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailReviewTableViewCell.reuseID, for: indexPath) as? BusinessDetailReviewTableViewCell,
              let reviewViewModel = self.reviewListViewModel.reviewViewModel(for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(reviewViewModel: reviewViewModel)
        return cell
    }
    
}
