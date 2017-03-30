//
//  CreateNewPrivateGroupHandler.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension CreatePrivateGroupViewController{

    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataWeekDays.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataWeekDays[row]
    }
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardDidHide , object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
        return false
    }
    func hideKeyboard(){
        self.nameOfGroup.endEditing(true)
        self.locationOfMeeting.endEditing(true)
    }
}
