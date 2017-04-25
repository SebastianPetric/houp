//
//  MakeRequestPrivateGroupViewController.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class MakeRequestPrivateGroupViewController: UIViewController, UITextFieldDelegate {
    
    let secretTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.enterSecretID.rawValue, keyboardType: .default, isPasswordField: false, backgroundColor: UIColor().getSecondColor())
    let requestButton = CustomViews.shared.getCustomButton(title: GetString.makeRequestToPrivateGroup.rawValue)
    var positiveResponse = UIView()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(secretTextField)
        secretTextField.delegate = self
        view.addSubview(requestButton)
        requestButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
    secretTextField.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 146.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
     requestButton.addConstraintsWithConstants(top: secretTextField.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
}
