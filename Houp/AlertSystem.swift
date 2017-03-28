//
//  AlertSystem.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class AlertSystem{

    static let shared: AlertSystem = AlertSystem()

    func setUpAlertWindow(view: UIViewController, title: String, message: String, positivTitle: String, negativeTitle: String, positiveHandler: ()->(), negativeHandler: ()->()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: GetString.errorOKButton.rawValue, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

