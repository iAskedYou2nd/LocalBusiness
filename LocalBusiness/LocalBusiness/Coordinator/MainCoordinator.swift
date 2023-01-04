//
//  MainCoordinator.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import UIKit
import Combine

class MainCoordinator: NSObject, CoordinatorType {
    
    lazy var debugButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.setImage(UIImage(named: "question-mark"), for: .normal)
        button.isEnabled = false
        button.isHidden = true
        button.addTarget(self, action: #selector(self.presentDebugMenu), for: .touchUpInside)
        return button
    }()
    
    let navigationController: UINavigationController
    var subs = Set<AnyCancellable>()
    
    init(navC: UINavigationController = UINavigationController()) {
        self.navigationController = navC
    }
    
    func launch() {
        let viewModel = BusinessListViewModel()
        let launchVC = BusinessListViewController(viewModel: viewModel)
        self.navigationController.delegate = self
        self.navigationController.setViewControllers([launchVC], animated: false)
    }
    
    func bindToLocationServices() {
        LocationManager.shared.$coordinate
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("Location updated")
                self.launch()
            }.store(in: &self.subs)
    }
    
    @objc
    func presentDebugMenu() {
        let debugVC = DebugViewController()
        debugVC.delegate = self
        debugVC.modalPresentationStyle = .fullScreen
        debugVC.modalTransitionStyle = .crossDissolve
        self.navigationController.present(debugVC, animated: true, completion: nil)
    }
    
}

extension MainCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        #if DEBUG
            viewController.view.addSubview(self.debugButton)
            self.debugButton.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            self.debugButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            self.debugButton.isEnabled = true
            self.debugButton.isHidden = false
        #endif
        
        if let _ = viewController as? BusinessListViewController {
            debugPrint("Log: Navigated to Business List")
        } else {
            debugPrint("Log: Navigated to Business Details")
        }
        
    }
    
}

extension MainCoordinator: DebuggerDelegate {
    
    func restartApp() {
        self.navigationController.dismiss(animated: true) {
            self.launch()
        }
    }
    
}
