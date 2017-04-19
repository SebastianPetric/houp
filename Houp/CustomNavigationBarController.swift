//
//  CustomNavigationBarController.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CustomNavigationBarController{

    static var shared: CustomNavigationBarController = CustomNavigationBarController()
    
    func getCustomNavControllerWithNameAndImage(customController: UIViewController,navBarTitle: String, barItemTitle: String?, image: String?) -> UINavigationController{
        customController.view.backgroundColor = .white
        let dummyController = UINavigationController(rootViewController: customController)
        dummyController.navigationBar.isTranslucent = false
        dummyController.navigationBar.barTintColor = UIColor().getMainColor()
        dummyController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        dummyController.navigationBar.tintColor = .white
        dummyController.navigationBar.topItem?.title = navBarTitle
        
        if(image != nil){
        dummyController.tabBarItem.title = barItemTitle!
        dummyController.tabBarItem.image = UIImage(named: image!)
        }
        dummyController.navigationBar.layer.addSublayer(CustomViews.shared.getCustomBarBorder(x: 0, y: dummyController.navigationBar.frame.height))
        
        return dummyController
    }
}
