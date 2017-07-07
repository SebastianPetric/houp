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
    let profileButton = CustomViews.shared.getCustomButton(title: "Profil bearbeiten")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoutButton)
        view.addSubview(profileButton)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(handleProfile), for: .touchUpInside)
        setUpSubViews()
    }
    
    private func setUpSubViews(){
    profileButton.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    logoutButton.addConstraintsWithConstants(top: profileButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        }
    }

