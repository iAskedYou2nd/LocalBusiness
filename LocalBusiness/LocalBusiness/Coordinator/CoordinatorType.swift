//
//  CoordinatorType.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import UIKit

protocol CoordinatorType {
    var navigationController: UINavigationController { get }
    func launch()
    func bindToLocationServices()
}
