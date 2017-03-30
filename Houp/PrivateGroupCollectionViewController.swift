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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.secret_icon.rawValue), style: .plain, target: self, action: #selector(handleMakeRequestPrivateGroup))
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:GetString.logoutIcon.rawValue), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateNewPrivateGroup))
    }
    
    func handleLogout(){
        UserDefaults.standard.removeObject(forKey: GetString.username.rawValue)
        
        let loginNavController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
        present(loginNavController, animated: true, completion: nil)
        
    }
    
    func handleCreateNewPrivateGroup(){
       let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreatePrivateGroupViewController(),navBarTitle: GetString.privateGroup.rawValue, barItemTitle: "", image: "")
        present(createController, animated: true, completion: nil )
    }
    
    func handleMakeRequestPrivateGroup(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: MakeRequestPrivateGroupViewController(),navBarTitle: GetString.makeRequestToPrivateGroup.rawValue, barItemTitle: "", image: "")
        present(createController, animated: true, completion: nil )
    }

}
