//
//  CalendarObject.swift
//  Houp
//
//  Created by Sebastian on 23.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation
import EventKit

class CalendarObject{

    static let shared: CalendarObject = CalendarObject()


    func setUpEventInCalendar(activity: String,locationOfActivity: String?, dateOfActivity: Date){
    
        let eventStore : EKEventStore = EKEventStore()
        // wenn man ein spezielles Event aus dem Kalender will braucht man event.eventIdentifier
        // um dann mit: eventStore.event(withIdentifier: "") das event zu erhalten
        
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = activity
                event.startDate = dateOfActivity
                if let location = locationOfActivity{
                    event.location = location
                }
                let reminder = Calendar.current.date(byAdding: .minute, value: -60, to: dateOfActivity)
                let endDate = Calendar.current.date(byAdding: .minute, value: 30, to: dateOfActivity)
                
                event.endDate = endDate!
                event.notes = "Viel Spaß bei deiner Auszeit heute!"
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(EKAlarm(absoluteDate: reminder!))
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
            }
            else{
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
}
