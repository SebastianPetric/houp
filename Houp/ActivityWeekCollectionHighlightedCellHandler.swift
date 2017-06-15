//
//  ActivityWeekCollectionHighlightedCellHandler.swift
//  Houp
//
//  Created by Sebastian on 15.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityWeekHighlightedCell{
    func handleEditActivity(){
        let controller = EditActivity()
        controller.activityWeekCollection = self.activityWeekCollectionDelegate
        controller.activity = self.activityObject
        let editController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: controller,navBarTitle: (self.activityObject?.dateObject?.getDatePartWithDay())!, barItemTitle: nil, image: nil)
        self.activityWeekCollectionDelegate?.present(editController, animated: true, completion: nil )
    }
}
