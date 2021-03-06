//
//  CreateActivityWeekController.swift
//  Houp
//
//  Created by Sebastian on 09.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ActivityWeekForm6: UIViewController, UITextFieldDelegate{
    
    var activityWeekCollection: ActivityWeekCollection?
    var activityList: [Activity] = [Activity]()
    var activity: Activity?
    var positiveResponse = UIView()
    let titleHeader = CustomViews.shared.getCustomLabel(text: "Was würdest du gerne unternehmen?", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .center, textColor: .black)
    let activityText = CustomViews.shared.getCustomTextField(placeholder: "z.B. mit Freunden treffen", keyboardType: .default, isPasswordField: false, textColor: .black, backgroundColor: UIColor().getFourthColor())
    let locationText = CustomViews.shared.getCustomTextField(placeholder: "Ort (freiwillig)", keyboardType: .default, isPasswordField: false,textColor: .black, backgroundColor: UIColor().getFourthColor())
    let timeOfActivity = CustomViews.shared.getCustomPickerViewWithTitle(title: "Uhrzeit", titleColor: .black, pickerMode: .time)
    let dateActivity = CustomViews.shared.getCustomLabel(text: "Heute", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .black)
    let continueButton = CustomViews.shared.getCustomButton(title: "Weiter", borderColor: .black, textColor: .black)
    let progressbar = CustomViews.shared.getCustomProgressionView(status: 0.8571428571, statusText: "6 von 7", progressColor: UIColor().getFourthColor())
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = .white
        view.addSubview(dateActivity)
        view.addSubview(titleHeader)
        view.addSubview(activityText)
        activityText.delegate = self
        view.addSubview(locationText)
        locationText.delegate = self
        view.addSubview(timeOfActivity)
        view.addSubview(continueButton)
        self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
        self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        view.addSubview(progressbar)
        view.addGestureRecognizer(gestureRecognizer)
        continueButton.addTarget(self, action: #selector(continueWeek), for: .touchUpInside)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        titleHeader.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 25, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        activityText.addConstraintsWithConstants(top: titleHeader.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        locationText.addConstraintsWithConstants(top: activityText.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 40)
        timeOfActivity.addConstraintsWithConstants(top: locationText.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 65)
        progressbar.addConstraintsWithConstants(top: timeOfActivity.bottomAnchor, right: continueButton.rightAnchor, bottom: nil, left: continueButton.leftAnchor, centerX: nil, centerY: nil, topConstant: 12.5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 25)
        continueButton.addConstraintsWithConstants(top: progressbar.bottomAnchor, right: activityText.rightAnchor, bottom: nil, left: activityText.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(self.activityText.text! != ""){
            self.continueButton.layer.borderColor = UIColor.black.cgColor
            self.continueButton.setTitleColor(.black, for: .normal)
        }else{
            self.continueButton.layer.borderColor = UIColor().getLightGreyColor().cgColor
            self.continueButton.setTitleColor(UIColor().getLightGreyColor(), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
