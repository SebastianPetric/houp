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
            print("upps")
            self.init(timeInterval:0, since: Date())
        }
    }
    
    func getDatePart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    func getTimePart() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func getFormattedStringFromDate(time: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.hour, .minute], from: time)
        let hour = comp.hour
        let minute = comp.minute
        return "\(hour!):\(minute!)"
    }
}
