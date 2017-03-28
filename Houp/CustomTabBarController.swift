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
        
        let privateGroupController = getViewControllerWithNameAndImage(customController: PrivateGroupCollectionViewController(),navBarTitle: GetString.navBarPrivateGroup.rawValue, barItemTitle: GetString.tabBarPrivateGroup.rawValue, image: GetString.privateGroupBarIcon.rawValue)
        let publicGroupController = getViewControllerWithNameAndImage(customController: PublicGroupCollectionViewController(),navBarTitle: GetString.navBarPublicGroup.rawValue, barItemTitle: GetString.tabBarPublicGroup.rawValue, image: GetString.publicGroupBarIcon.rawValue)
        let activityController = getViewControllerWithNameAndImage(customController: ActivityCollectionViewController(),navBarTitle: GetString.navBarActivity.rawValue, barItemTitle: GetString.tabBarActivity.rawValue, image: GetString.activityBarIcon.rawValue)
        let settingsController = getViewControllerWithNameAndImage(customController: SettingsCollectionViewController(),navBarTitle: GetString.navBarSettings.rawValue, barItemTitle: GetString.tabBarSettings.rawValue, image: GetString.moreIcon.rawValue)

        viewControllers = [privateGroupController, publicGroupController, activityController,settingsController]
    }

    private func getViewControllerWithNameAndImage(customController: UIViewController,navBarTitle: String, barItemTitle: String, image: String) -> UINavigationController{
        let dummyController = UINavigationController(rootViewController: customController)
        dummyController.navigationBar.isTranslucent = false
        dummyController.navigationBar.barTintColor = UIColor(red: 101, green: 232, blue: 100, alphaValue: 1)
        dummyController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        dummyController.navigationBar.tintColor = .white
        dummyController.tabBarItem.title = barItemTitle
        dummyController.navigationBar.topItem?.title = navBarTitle
        dummyController.tabBarItem.image = UIImage(named: image)
        
        let bottomorder = CALayer()
        bottomorder.frame = CGRect(x: 0, y: dummyController.navigationBar.frame.height, width: 1000, height: 0.5)
        bottomorder.backgroundColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 1).cgColor
        dummyController.navigationBar.layer.addSublayer(bottomorder)
        
        return dummyController
    }
    
}
