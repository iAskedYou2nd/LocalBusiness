//
//  BusinessListViewController.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import UIKit
import Combine

class BusinessListViewController: UIViewController {

    lazy var businessTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(BusinessListTableViewCell.self, forCellReuseIdentifier: BusinessListTableViewCell.reuseID)
        // MARK: Started to create categories but did not have time to complete
        table.register(BusinessCategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: BusinessCategoryHeaderView.reuseID)
        return table
    }()
    
    var viewModel: BusinessListViewModel
    var subs = Set<AnyCancellable>()
    
    init(viewModel: BusinessListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buildUI()
        
        self.viewModel.$businesses
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                debugPrint("Reload Requested")
                self.businessTable.reloadData()
            }.store(in: &self.subs)
        
        self.viewModel.fetchBusinesses()
    }
    
    private func buildUI() {
        self.view.backgroundColor = .white
        self.title = "Restaurants Near You"
        
        self.view.addSubview(self.businessTable)
        self.businessTable.bindToSuperView()
    }

}

extension BusinessListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BusinessCategoryHeaderView.reuseID) as? BusinessCategoryHeaderView else { return nil }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessListTableViewCell.reuseID, for: indexPath) as? BusinessListTableViewCell,
              let businessViewModel = self.viewModel.businessViewModel(for: indexPath)
        else {
            return UITableViewCell()
        }
                
        cell.configure(businessViewModel: businessViewModel)
        
        return cell
    }
    
    
}

// TODO: Maybe move to up top
extension BusinessListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let businessViewModel = self.viewModel.businessViewModel(for: indexPath) else { return }
        let vc = BusinessDetailViewController(businessViewModel: businessViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
