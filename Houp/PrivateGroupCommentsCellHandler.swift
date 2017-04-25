//
//  PrivateGroupCommentsCellHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupCommentsCell{

    func handleUpvote(){
        if(self.upvoteButton.tintColor == .black){
            self.upvoteButton.tintColor = UIColor().getThirdColor()
        }else{
            self.upvoteButton.tintColor = .black
        }
    }
}
