//
//  PrivateGroupWithThreadsControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupWithThreadsController{
    func handleCreateThread(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreateGroupThreadController(), navBarTitle: "Thema erstellen", barItemTitle: "", image: "")
        self.present(createController, animated: true, completion: nil)
    }
}
