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
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.layer.addSublayer(CustomViews.shared.getCustomBarBorder(x: 0, y: 0))
        
        
        let activityWeek = ActivityWeekCollection()
        let privateControl = PrivateGroupCollectionViewController()
            privateControl.tabBarContr = self
            privateControl.activityCollection = activityWeek
        let privateGroupController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: privateControl,navBarTitle: GetString.navBarPrivateGroup.rawValue, barItemTitle: GetString.tabBarPrivateGroup.rawValue, image: GetString.privateGroupBarIcon.rawValue)
        let publicGroupController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: PublicGroupThreadsController(),navBarTitle: GetString.navBarPublicGroup.rawValue, barItemTitle: GetString.tabBarPublicGroup.rawValue, image: GetString.publicGroupBarIcon.rawValue)
        let activityController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: activityWeek,navBarTitle: GetString.navBarActivity.rawValue, barItemTitle: GetString.tabBarActivity.rawValue, image: GetString.activityBarIcon.rawValue)
        let settingsController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: SettingsCollectionViewController(),navBarTitle: GetString.navBarSettings.rawValue, barItemTitle: GetString.tabBarSettings.rawValue, image: GetString.moreIcon.rawValue)

        viewControllers = [privateGroupController, publicGroupController, activityController,settingsController]
    }
}
