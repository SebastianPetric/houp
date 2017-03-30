//
//  MakeRequestPrivateGroupViewController.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class MakeRequestPrivateGroupViewController: UIViewController, UITextFieldDelegate {
    
    let secretTextField = CustomViews.shared.getCustomTextField(placeholder: GetString.enterSecretID.rawValue, isPasswordField: false)
    let requestButton = CustomViews.shared.getCustomButton(title: GetString.makeRequestToPrivateGroup.rawValue)
    let blackBackground = UIView()
    //let didTapCancelButton = #selector(handleCancel)
    //let didTapOkButton = #selector(handleOk)
 
    
    let responseContainer = { (hasErrorOccured: Bool) -> UIView in
       
        
        let responseTitle: UITextView = {
            let responseTitle = UITextView()
            responseTitle.text = "Header"
            responseTitle.textAlignment = .center
            responseTitle.font = UIFont.boldSystemFont(ofSize: 20)
            responseTitle.textColor = UIColor().getSecondColor()
            responseTitle.isEditable = false
            return responseTitle
        }()
        
        let responseMessage: UITextView = {
            let responseMessage = UITextView()
            responseMessage.textColor = UIColor().getSecondColor()
            responseTitle.font = UIFont.systemFont(ofSize: 20)
            responseMessage.textAlignment = .center
            responseMessage.text = "SecretID: 59IfwV22"
            responseMessage.isEditable = false
            return responseMessage
        }()
        
        let okButton = CustomViews.shared.getCustomButton(title: "Ok")
        let cancelButton = CustomViews.shared.getCustomButton(title: "Zurück zum Home")
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor().getSecondColor().cgColor
        view.layer.borderWidth = 1
        view.addSubview(responseTitle)
        view.addSubview(responseMessage)
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        
        responseTitle.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
        responseMessage.addConstraintsWithConstants(top: responseTitle.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 20, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
//        var widthOK: CGFloat?
//        var widthCancel: CGFloat?
//        var heightOK: CGFloat?
//        var heightCancel: CGFloat = 40
//        
//        
//        if(hasErrorOccured){
//        widthOK = view.frame.width/2
//        widthCancel = view.frame.width/2
//        heightOK = 40
//        }else{
//        widthOK = 0
//        widthCancel = view.frame.width
//        heightOK = 0
//        }
//        
//        okButton.addConstraintsWithConstants(top: nil, right: nil, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: widthOK!, height: heightOK!)
//        
//        cancelButton.addConstraintsWithConstants(top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, left: okButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: widthCancel!, height: heightCancel)
        return view
    }
    
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
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleRequest(){
    
        if let window = UIApplication.shared.keyWindow{
        
            blackBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackBackground.frame = window.frame
            blackBackground.alpha = 0
            let response: UIView = responseContainer(true)
            blackBackground.addSubview(response)
            response.addConstraintsWithConstants(top: nil, right: blackBackground.rightAnchor, bottom: nil, left: blackBackground.leftAnchor, centerX: nil, centerY: blackBackground.centerYAnchor, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 150)
           
            window.addSubview(blackBackground)
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.blackBackground.alpha = 1
            }, completion: nil)
        
        }
    }
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func handleDismiss(){
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
        self.blackBackground.alpha = 0
    }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
