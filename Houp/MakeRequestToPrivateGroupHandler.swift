//
//  MakeRequestToPrivateGroupHandler.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension MakeRequestPrivateGroupViewController{

    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    
    func handleRequest(){
            if let error = DBConnection.shared.makeRequestToPrivateGroup(secretID: self.secretTextField.text!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.navController?.popToRootViewController(animated: true)
                if let window = UIApplication.shared.keyWindow{
                    self.positiveResponse = CustomViews.shared.getPositiveResponse(title: GetString.successMadeRequestPrivateGroupTitle.rawValue, message: GetString.successMadeRequestPrivateGroupMessage.rawValue)
                    self.positiveResponse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                    self.positiveResponse.frame = window.frame
                    window.addSubview(positiveResponse)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.positiveResponse.alpha = 1
                    }, completion: nil)
                }
            }
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.positiveResponse.alpha = 0
            self.dismiss(animated: true, completion: nil)
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
