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
        if let error = DBConnection.shared.denyRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func acceptUser(){
        if let error = DBConnection.shared.acceptRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func leaveGroup(){
        if let error = DBConnection.shared.leaveGroup(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
