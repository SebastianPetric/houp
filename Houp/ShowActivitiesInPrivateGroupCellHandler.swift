//
//  ShowActivitiesInPrivateGroupCellHandler.swift
//  Houp
//
//  Created by Sebastian on 16.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ShowActivitiesInPrivateGroupCell{
    
    func handleUpvote(){
        if(self.upvoteButton.tintColor == .black){
            if let error = DBConnection.shared.likeActivity(aID: (activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = UIColor().getMainColor()
            }
            
        }else{
            if let error = DBConnection.shared.dislikeActivity(aID: (activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = .black
            }
        }
    }
}
