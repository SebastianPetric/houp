//
//  DateExtension.swift
//  Houp
//
//  Created by Sebastian on 12.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension Date{

    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        if let date = dateStringFormatter.date(from: dateString){
        self.init(timeInterval:0, since:date)
        }else{
            self.init(timeInterval:0, since: Date())
        }
    }
    
    func getDateTimeFormatted() -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        return dateformatter.string(from: self)
    }
    
    func getDatePart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    
    func getDatePartWithDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    func getTimePart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func getDateAndTimeForActity(date: Date, time: Date) -> Date{
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        // Change the time to 9:30:00 in your locale
        
        components.hour = Calendar.current.component(.hour, from: time)
        components.minute = Calendar.current.component(.minute, from: time)
        components.second = 00
        return gregorian.date(from: components)!
    }

    func checkIfActivityAlreadyOver(date: Date) -> Date{
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        // Change the time to 9:30:00 in your locale
        components.hour = 20
        components.minute = 00
        components.second = 00
        return gregorian.date(from: components)!
    }
    
    func checkIfActivityAlreadyOver(activityDate: Date) -> Bool{
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: activityDate)
        // Change the time to 9:30:00 in your locale
        components.hour = 20
        components.minute = 00
        components.second = 00
        let dateO = gregorian.date(from: components)!
        
        if(dateO < Date()){
            return true
        }
        return false
    }



}
