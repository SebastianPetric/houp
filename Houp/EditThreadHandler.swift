//
//  EditThreadHandler.swift
//  Houp
//
//  Created by Sebastian on 24.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension EditThread{
    
    func handleUpdate(){
        
        let threadObject = self.thread
        if(self.titleThread.text! != ""){
            threadObject?.title = self.titleThread.text!
        }
        
        if(self.messageThread.text! != ""){
            threadObject?.message = self.messageThread.text!
        }
        
        if let error = DBConnection.shared.updateThread(properties: threadObject!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            if let window = UIApplication.shared.keyWindow{
                self.positiveResponse = CustomViews.shared.getPositiveResponse(title: "Super!", message: "Du hast dein Thema erfolgreich editiert!")
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
}
