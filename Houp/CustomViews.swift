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
    
    func getCustomTextField(placeholder: String,keyboardType: UIKeyboardType, isPasswordField: Bool) -> CustomTextField {
            let customTextField = CustomTextField()
            customTextField.backgroundColor = UIColor().getSecondColor()
            customTextField.textColor = .white
            customTextField.keyboardType = keyboardType
            customTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white])
            customTextField.layer.cornerRadius = 5
            customTextField.isSecureTextEntry = isPasswordField
            customTextField.clearButtonMode = .always
            return customTextField
    }

    func getCustomButton(title: String) -> UIButton{
            let customButton = UIButton(type: .system)
            customButton.setTitle(title, for: .normal)
            customButton.layer.cornerRadius = 5
            customButton.setTitleColor(UIColor().getSecondColor(), for: .normal)
            customButton.layer.borderColor = UIColor().getSecondColor().cgColor
            customButton.layer.borderWidth = 1
            customButton.tintColor = .black
            return customButton
    }
    
    func getCustomLabel(text: String, fontSize: CGFloat,isBold: Bool, textAlignment: NSTextAlignment, textColor: UIColor?) -> UILabel{
        let customLabel = UILabel()
        customLabel.numberOfLines = 2
        if(textColor != nil){
            customLabel.textColor = textColor
        }else{
            customLabel.textColor = .black
        }
        if(isBold){
            customLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        }else{
            customLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
        customLabel.textAlignment = textAlignment
            customLabel.text = text
        return customLabel
    }
    
    func getCustomButtonWithImage(imageName: String, backgroundColor: UIColor, imageColor: UIColor, radius: CGFloat?, borderColor: UIColor?) -> UIButton{
        let customButton = UIButton()
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        customButton.setImage(image, for: .normal)
        customButton.backgroundColor = backgroundColor
        customButton.tintColor = imageColor
        
        if let corRadius = radius{
        customButton.layer.cornerRadius = corRadius
        }
        customButton.layer.borderWidth = 1
        if let borColor = borderColor{
        customButton.layer.borderColor = borderColor?.cgColor
        }else{
        customButton.layer.borderColor = UIColor.white.cgColor
        }
      return customButton
    }
    
    
    func getCustomWriteCommentContainer() -> UIView{
            let commentSection = CustomViews.shared.getCustomTextField(placeholder: "Kommentar verfassen", keyboardType: .default, isPasswordField: false)
            //let sendButton = CustomViews.shared.getCustomImageView(imageName: "send_icon", cornerRadius: 0, isUserInteractionEnabled: true, imageColor: UIColor().getSecondColor(), borderColor: .white)
        let sendButton = getCustomButtonWithImage(imageName: "send_icon", backgroundColor: UIColor().getSecondColor(), imageColor: .white, radius: nil, borderColor: UIColor().getSecondColor())
            let container = UIView()
            container.layer.zPosition = CGFloat.greatestFiniteMagnitude
            container.backgroundColor = UIColor().getSecondColor()
            container.addSubview(commentSection)
            container.addSubview(sendButton)
            
            sendButton.addConstraintsWithConstants(top: container.topAnchor, right: container.rightAnchor, bottom: container.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: container.frame.height, height: container.frame.height)
            commentSection.addConstraintsWithConstants(top: container.topAnchor, right: sendButton.leftAnchor, bottom: container.bottomAnchor, left: container.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: container.frame.height)
            return container
    }
    
    func getCustomImageView(imageName: String, cornerRadius: CGFloat, isUserInteractionEnabled: Bool,imageColor: UIColor?, borderColor: UIColor) -> UIImageView{
            let customImageView = UIImageView()
            customImageView.image = UIImage(named: imageName)
        if(imageColor != nil){
            customImageView.image = customImageView.image?.withRenderingMode(.alwaysTemplate)
            customImageView.tintColor = imageColor
        }
            customImageView.contentMode = .scaleAspectFit
            customImageView.clipsToBounds = true
            customImageView.layer.masksToBounds = true
            customImageView.backgroundColor = .white
            customImageView.layer.cornerRadius = cornerRadius
            customImageView.layer.borderColor = borderColor.cgColor
            customImageView.layer.borderWidth = 1
            customImageView.isUserInteractionEnabled = isUserInteractionEnabled
            return customImageView
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
    
    func getCustomTextView(text: String, fontSize: CGFloat, textAlignment: NSTextAlignment, color: UIColor?) -> UITextView{
    let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.5
        
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
    let textView = UITextView()
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        textView.isEditable = false
        textView.isScrollEnabled = false
        if(color != nil){
        textView.textColor = color
        }
        textView.textAlignment = textAlignment
        textView.font = UIFont.systemFont(ofSize: fontSize)
    return textView
    }
    
    func getCustomTextViewContainer(text: String, fontSize: CGFloat,isBold: Bool, textAlignment: NSTextAlignment, textColor: UIColor?, borderColor: UIColor?, backgroundColor: UIColor?) -> UITextView{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.5
        
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
        let textView = UITextView()
        textView.text = text
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        textView.isEditable = true
        textView.isScrollEnabled = true
        if(textColor != nil){
            textView.textColor = textColor
        }
        if(backgroundColor != nil){
        textView.backgroundColor = backgroundColor
        }
        if(borderColor != nil){
            textView.layer.borderWidth = 1
            textView.layer.borderColor = borderColor?.cgColor
            textView.layer.cornerRadius = 5
        }
        if(isBold){
        textView.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
        textView.textAlignment = textAlignment
        textView.font = UIFont.systemFont(ofSize: fontSize)
        return textView
    }

    
    func getCustomBarBorder(x: CGFloat, y: CGFloat) -> CALayer{
        let border = CALayer()
        border.frame = CGRect(x: x, y: y, width: 1000, height: 0.5)
        border.backgroundColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 0.5).cgColor
        return border
    }
    
    func getCustomSeperator(color: UIColor) -> UIView{
        let seperator = UIView()
        //seperator.backgroundColor = UIColor(red: 229, green: 231, blue: 235, alphaValue: 1)
        seperator.backgroundColor = color
        return seperator
    }
    
    func getCustomPickerViewWithTitle(title: String, pickerMode: UIDatePickerMode) -> UIView {
       
            let pickerTitle = getCustomLabel(text: title, fontSize: 16, isBold: true, textAlignment: .left, textColor: UIColor().getSecondColor())
        
      
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
