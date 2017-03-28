//
//  PrivateGroupCollectionViewController.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupCollectionViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:GetString.logoutIcon.rawValue), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateNewPrivateGroup))
    }
    
    func handleLogout(){
        UserDefaults.standard.removeObject(forKey: GetString.username.rawValue)
        let loginNavController = UINavigationController(rootViewController: LoginViewController())
        present(loginNavController, animated: true, completion: nil)
    }
    
    func handleCreateNewPrivateGroup(){
    // Viewcontroller öffnen um private gruppe zu erstellen
    }
}
