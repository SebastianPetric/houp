//
//  ActivitiesCommentsCellHandler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivitiesCommentsCell{
    
    func handleUpvote(){
        if(self.upvoteButton.tintColor == .black){
            if let error = DBConnection.shared.likeComment(cID: (comment?.cid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = UIColor().getThirdColor()
            }
            
        }else{
            if let error = DBConnection.shared.dislikeComment(cID: (comment?.cid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = .black
            }
        }
    }
}
