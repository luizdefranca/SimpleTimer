//
//  NotificationManager.swift
//  SimpleClock
//
//  Created by Luiz on 4/22/21.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject //, UNUserNotificationCenterDelegate
{

    static let shared = NotificationManager()
    var myNotificationCenter = UNUserNotificationCenter.current()
    private var identifiers = [String]()
    weak var timeViewDelegate : TimerViewControllerDelegate?
    private override init(){
        super.init()
    //    myNotificationCenter.delegate = self
    }

    func askPermission() {
        myNotificationCenter.requestAuthorization(options: [.alert, .sound]) {granted, error in
          if granted {
            print("Notification allowed")
          } else {
            print("Notification Denied")
          }
        }
    }
    func scheduleNotification(id: Int, timeInterval: TimeInterval, title: String, body: String){
        identifiers.append("\(id)")
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
        content.sound = UNNotificationSound.default

    //        let calendar = Calendar(identifier: .gregorian)
    //        let components = calendar.dateComponents(
    //            [.year, .month, .day, .hour, .minute],
    //            from: dueDate)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

            let request = UNNotificationRequest(
                identifier: "\(id)",
                content: content,
                trigger: trigger)

            let mainQueue = OperationQueue.main

            myNotificationCenter.add(request)


        }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {


            if let delegate = self.timeViewDelegate {
                delegate.stopTimer()
            }
        print("notification finished")
    }


    func cancelNotification() {
        if identifiers.isEmpty {
            return
        }
        myNotificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
        myNotificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)

    }
    
}

