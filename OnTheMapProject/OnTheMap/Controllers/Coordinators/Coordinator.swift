//
//  Coordinator.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/31/20.
//  Copyright © 2020 DevTrain. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func viewAddLocationVC()
    func viewStudentsLocations()
    func getFacebookData()
}
