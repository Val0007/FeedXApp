//
//  NotificationService.swift
//  FeedX
//
//  Created by Val V on 26/11/22.
//

import Foundation
import NotificationCenter

struct NotificationManager{
    
    func requestAuthorization(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            // Enable or disable features based on the authorization.
            if granted{
                print("YES")
                makeCategories()
            }
        }
        
    }
    
    func status(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized{
                print("Authorized")
            }
            if settings.authorizationStatus == .denied{
                print("Failed")
                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { bool in
                        print(bool)
                    }
                }

            }
            else{
                requestAuthorization()
            }
        }

    }
    
    func makeCategories(){
        
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Read now",
                                                options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Add to later",
                                                 options: [.destructive])
        // Define the notification type
        let readCategory =
              UNNotificationCategory(identifier: "Read_Invite",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([readCategory])
    }
    
    func sendNotification2(){
        let content = UNMutableNotificationContent()
        content.title = "New Article in Motorsport"
        content.body = "SURELY AFTER BG TASK CHANGE MAN!~!"
        content.userInfo = ["folder":"Motorsport","link":"https://wtf1.com/post/williams-wants-albon-to-stop-being-too-nice-and-push-the-team-harder/"]
        content.categoryIdentifier = "Read_Invite"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content,trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
            else{
                print("Scheduled")
            }
        }
    }

    
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "New Article in Motorsport"
        content.body = "Danile BACK TO REDBULL!?"
        content.userInfo = ["folder":"Motorsport","link":"https://wtf1.com/post/williams-wants-albon-to-stop-being-too-nice-and-push-the-team-harder/"]
        content.categoryIdentifier = "Read_Invite"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content,trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
            else{
                print("Scheduled")
            }
        }
    }

}
