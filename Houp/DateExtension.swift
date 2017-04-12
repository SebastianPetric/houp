//
//  DateExtension.swift
//  Houp
//
//  Created by Sebastian on 12.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension Date{

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
