//
//  PrivateGroupRequestsAndMembersCellHandler.swift
//  Houp
//
//  Created by Sebastian on 16.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupRequestsAndMembersCell{
    
    func denyUser(){
        showErrorIfNeeded(isError: DBConnection.shared.denyRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!))
    }
    
    func acceptUser(){
        showErrorIfNeeded(isError: DBConnection.shared.acceptRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!))
    }
    
    func leaveGroup(){
        if(!showErrorIfNeeded(isError: DBConnection.shared.leaveGroup(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!))){
            //Wenn man selber der Nutzer ist, der sich aus der Gruppe entfernt, muss sich der Nutzer auf der Unterseite befinden. Hier wird er an den obersten ViewController geschickt
            if(UserDefaults.standard.string(forKey: GetString.userID.rawValue) != self.privateGroup?.adminID){
                self.navController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func showErrorIfNeeded(isError: String?) -> Bool{
        if let error = isError{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return true
        }else{
            return false
        }
    }
    
    
}
