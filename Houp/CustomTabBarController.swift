//
//  Homescreen.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor().getMainColor()
        
        let privateGroupController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: PrivateGroupCollectionViewController(),navBarTitle: GetString.navBarPrivateGroup.rawValue, barItemTitle: GetString.tabBarPrivateGroup.rawValue, image: GetString.privateGroupBarIcon.rawValue)
        let publicGroupController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: PublicGroupCollectionViewController(),navBarTitle: GetString.navBarPublicGroup.rawValue, barItemTitle: GetString.tabBarPublicGroup.rawValue, image: GetString.publicGroupBarIcon.rawValue)
        let activityController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: ActivityCollectionViewController(),navBarTitle: GetString.navBarActivity.rawValue, barItemTitle: GetString.tabBarActivity.rawValue, image: GetString.activityBarIcon.rawValue)
        let settingsController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: SettingsCollectionViewController(),navBarTitle: GetString.navBarSettings.rawValue, barItemTitle: GetString.tabBarSettings.rawValue, image: GetString.moreIcon.rawValue)

        viewControllers = [privateGroupController, publicGroupController, activityController,settingsController]
    }
}
