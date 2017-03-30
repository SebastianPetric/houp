//
//  SettingsCollectionViewController.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class SettingsCollectionViewController: UIViewController{

    let logoutButton = CustomViews.shared.getCustomButton(title: GetString.logout.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        setUpSubViews()
    }
    
    private func setUpSubViews(){
    logoutButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
}
