//
//  PrivateGroupCollectionCellHandler.swift
//  Houp
//
//  Created by Sebastian on 14.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupsCell{
    func handleUsersInGroup(){
        let controller = PrivateGroupRequestAndMembersList()
        controller.privateGroup = self.privateGroup
        self.privateGroupCollectionDelegate?.navigationController?.pushViewController(controller, animated: true)
    }
}
