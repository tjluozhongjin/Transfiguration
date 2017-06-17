//
//  AgendaViewController.swift
//  DoorBell
//
//  Created by Yang Li on 04/06/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import FSCalendar

class AgendaViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    getAgenda()
  }
  
  func getAgenda() {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { (granted, error) in
      if (granted) && (error == nil) {
        let startDate = Date().addingTimeInterval(-3600 * 24 * 1)
        let endDate = Date().addingTimeInterval(3600 * 24 * 7)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        if let event = eventStore.events(matching: predicate) as [EKEvent]! {
          for iter in event {
            print("title \(iter.title)")
            print("start \(iter.startDate)")
            print("end \(iter.endDate)")
          }
        }
      }
    }
  }

}
