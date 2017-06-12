//
//  CustomErrors.swift
//  Houp
//
//  Created by Sebastian on 12.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class CustomErrors: NSObject {
    
    static var shared: CustomErrors = CustomErrors()
    
    func showError(viewController: UIViewController){
        let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
        viewController.present(alert, animated: true, completion: nil)
    }
}
