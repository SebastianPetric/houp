//
//  CustomProgressionView.swift
//  Houp
//
//  Created by Sebastian on 21.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CustomViews{

    static var shared: CustomViews = CustomViews()
    
    func getCustomTextField(placeholder: String, isPasswordField: Bool) -> CustomTextField {
            let customTextField = CustomTextField()
            customTextField.backgroundColor = UIColor().getSecondColor()
            customTextField.textColor = .white
            customTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white])
            customTextField.layer.cornerRadius = 5
            customTextField.isSecureTextEntry = isPasswordField
            customTextField.clearButtonMode = .always
            return customTextField
    }

    func getCustomButton(title: String) -> UIButton{
            let loginButton = UIButton(type: .system)
            loginButton.setTitle(title, for: .normal)
            loginButton.layer.cornerRadius = 5
            loginButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
            loginButton.layer.borderColor = UIColor().getSecondColor().cgColor
            loginButton.layer.borderWidth = 1
            loginButton.tintColor = .black
            return loginButton
    }
    
    func getCustomLabel(text: String, fontSize: CGFloat,isBold: Bool, centerText: Bool, textColor: UIColor?) -> UILabel{
        let responseMessage = UILabel()
        if(textColor != nil){
            responseMessage.textColor = textColor
        }else{
            responseMessage.textColor = .black
        }
        if(isBold){
            responseMessage.font = UIFont.boldSystemFont(ofSize: fontSize)
        }else{
            responseMessage.font = UIFont.systemFont(ofSize: fontSize)
        }
        if(centerText){
        responseMessage.textAlignment = .center
        }
            responseMessage.text = text
        //responseMessage.backgroundColor = .red
        return responseMessage
    }

    
    func getBigRoundImage(name: String, cornerRadius: CGFloat, isUserInteractionEnabled: Bool) -> UIImageView{
            let bigRoundImage = UIImageView()
            bigRoundImage.image = UIImage(named: name)
            bigRoundImage.contentMode = .scaleAspectFit
            bigRoundImage.clipsToBounds = true
            bigRoundImage.backgroundColor = .white
            bigRoundImage.layer.cornerRadius = cornerRadius
            bigRoundImage.layer.borderColor = UIColor().getSecondColor().cgColor
            bigRoundImage.layer.borderWidth = 1
            bigRoundImage.isUserInteractionEnabled = isUserInteractionEnabled
            bigRoundImage.translatesAutoresizingMaskIntoConstraints = false
            return bigRoundImage
    }
    
    func getCustomAlert(errorTitle: String, errorMessage: String, firstButtonTitle: String, secondButtonTitle: String?, firstHandler: ((UIAlertAction) -> Void)?, secondHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: firstButtonTitle, style: .default, handler: firstHandler))
        if(secondButtonTitle != nil){
        alert.addAction(UIAlertAction.init(title: secondButtonTitle, style: .default, handler: secondHandler))
        }
        return alert
    }
    
    func getCustomProgressionView(status: Float, statusText: String) -> UIView {
    
            let progresion = UIProgressView()
            progresion.progressTintColor = UIColor().getSecondColor()
            progresion.trackTintColor = .white
            progresion.layer.borderColor = UIColor().getTextViewBorderColor()
            progresion.layer.borderWidth = 1
            progresion.layer.cornerRadius = 3
            progresion.progress = status
            
            let progressionViewText = UITextView()
            progressionViewText.text = statusText
            progressionViewText.font = UIFont.systemFont(ofSize: 10)
            progressionViewText.textAlignment = .center
            progressionViewText.textColor = .black
            progressionViewText.isEditable = false
            
            let container = UIView()
            container.addSubview(progresion)
            container.addSubview(progressionViewText)
            progresion.addConstraintsWithConstants(top: container.topAnchor, right: container.rightAnchor, bottom: nil, left: container.leftAnchor, centerX: container.centerXAnchor, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 5)
            progressionViewText.addConstraintsWithConstants(top: progresion.bottomAnchor, right: container.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 50, height: 20)
            return container
    }
    

    func getPositiveResponse(title: String, message: String) -> UIView {
    
        let blackBackground = UIView()
        blackBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackBackground.alpha = 0
        
        let responseContainer = { (message: String) -> UIView in
            
            let responseTitle: UITextView = {
                let responseTitle = UITextView()
                responseTitle.text = title
                responseTitle.textAlignment = .center
                responseTitle.font = UIFont.boldSystemFont(ofSize: 20)
                responseTitle.textColor = UIColor().getSecondColor()
                responseTitle.isEditable = false
                return responseTitle
            }()
            
            let responseMessage: UITextView = {
                let responseMessage = UITextView()
                responseMessage.textColor = UIColor().getSecondColor()
                responseMessage.font = UIFont.systemFont(ofSize: 15)
                responseMessage.textAlignment = .center
                responseMessage.text = message
                responseMessage.isEditable = false
                return responseMessage
            }()
            
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 5
            view.layer.borderColor = UIColor().getSecondColor().cgColor
            view.layer.borderWidth = 1
            view.addSubview(responseTitle)
            view.addSubview(responseMessage)
            
            responseTitle.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: view.centerXAnchor, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
            responseMessage.addConstraintsWithConstants(top: responseTitle.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
            return view
        }

        
        let response: UIView = responseContainer(message)
        blackBackground.addSubview(response)
        response.addConstraintsWithConstants(top: nil, right: blackBackground.rightAnchor, bottom: nil, left: blackBackground.leftAnchor, centerX: nil, centerY: blackBackground.centerYAnchor, topConstant: 0, rightConstant: 50, bottomConstant: 0, leftConstant: 50, width: 0, height: 120)
        return blackBackground
    }
    
    func getCustomBarBorder(x: CGFloat, y: CGFloat) -> CALayer{
        let border = CALayer()
        border.frame = CGRect(x: x, y: y, width: 1000, height: 0.5)
        border.backgroundColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 0.5).cgColor
        return border
    }
    
    func getCustomCellSeperator() -> UIView{
        let seperator = UIView()
        seperator.backgroundColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 1)
        return seperator
    }
    
    func getCustomPickerViewWithTitle(title: String, pickerMode: UIDatePickerMode) -> UIView {
       
            let pickerTitle = getCustomLabel(text: title, fontSize: 16, isBold: true, centerText: false, textColor: UIColor().getSecondColor())
        
      
            let picker = UIDatePicker()
            picker.datePickerMode = pickerMode
        
        if(pickerMode == UIDatePickerMode.date){
            var components = DateComponents()
            let maxDate = Calendar.current.date(byAdding: components, to: Date())
            picker.maximumDate = maxDate
            components.year = -100
            let minDate = Calendar.current.date(byAdding: components, to: Date())
            picker.minimumDate = minDate
        }
    
        let container = UIView()
//        container.layer.cornerRadius = 5
//        container.layer.borderColor = UIColor().getSecondColor().cgColor
//        container.layer.borderWidth = 1
        container.addSubview(pickerTitle)
        container.addSubview(picker)
        pickerTitle.addConstraintsWithConstants(top: container.topAnchor, right: nil, bottom: nil, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 5, width: 200, height: 25)
        picker.addConstraintsWithConstants(top: pickerTitle.bottomAnchor, right: container.rightAnchor, bottom: nil, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 40)
        return container
    }
    
}
