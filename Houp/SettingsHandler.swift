//
//  SettingsHandler.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension SettingsCollectionViewController{

    func handleProfile(){
            let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: EditProfile(), navBarTitle: "Profil bearbeiten", barItemTitle: nil, image: nil)
            self.present(createController, animated: true, completion: nil)
    }
    
    func handleLogout(){
        TempStorageAndCompare.shared.deinitialiseNotificationQueries()
        TimerObject.shared.deinitialiseTimer()
        UserDefaults.standard.removeObject(forKey: GetString.userID.rawValue)
        let loginNavController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: LoginViewController(),navBarTitle: GetString.appName.rawValue, barItemTitle: "", image: "")
        present(loginNavController, animated: true, completion: nil)
    }
}
