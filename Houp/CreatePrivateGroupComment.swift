//
//  CreatePrivateGroupComment.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CreatePrivateGroupComment: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    let titleThread = CustomViews.shared.getCustomTextField(placeholder: "Titel", keyboardType: .default, isPasswordField: false)
    //let messageThread = CustomViews.shared.getCustomTextField(placeholder: "Thema", keyboardType: .default, isPasswordField: false)
    let messageThread = CustomViews.shared.getCustomTextViewContainer(text: "", fontSize: 12, textAlignment: .left, textColor: .white, borderColor: .white, backgroundColor: UIColor().getSecondColor())
    let createButton = CustomViews.shared.getCustomButton(title: "Thread erstellen")
    
    var positiveResponse = UIView()
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.cancel_icon.rawValue), style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(titleThread)
        view.addSubview(messageThread)
        titleThread.delegate = self
        messageThread.delegate = self
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        view.addGestureRecognizer(gestureRecognizer)
        //addNotificationObserver()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleThread.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 34, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        messageThread.addConstraintsWithConstants(top: titleThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 100)
        createButton.addConstraintsWithConstants(top: messageThread.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
    }
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func handleCreate(){}
    func hideKeyboard(){}
}
