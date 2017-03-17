//
//  ViewController.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class LogRegViewController: UIViewController {

    let vie: UIView = {
    let v = UIView()
        v.backgroundColor = .red
    return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(vie)
        vie.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, topConstant: 20, rightConstant: 20, bottomConstant: 20, leftConstant: 20, width: 0, height: 0)
    }
}

