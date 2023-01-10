//
//  AppDelegate.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
 
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   // Register Background task here
      registerBackgroundTasks()
      return true
  }
 
  func registerBackgroundTasks() {
    // Declared at the "Permitted background task scheduler identifiers" in info.plist
    let backgroundAppRefreshTaskSchedulerIdentifier = "com.FeedX.backgroundAlerts"
    //let backgroundProcessingTaskSchedulerIdentifier = "com.FeedX.processingTask"

    // Use the identifier which represents your needs
    BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
       print("BackgroundAppRefreshTaskScheduler is executed NOW!")
       print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
        UserDefaults.standard.set(true, forKey: "backk")
        NotificationManager().sendNotification2()
       task.expirationHandler = {
         task.setTaskCompleted(success: false)
       }

       // Do some data fetching and call setTaskCompleted(success:) asap!
       let isFetchingSuccess = true
       task.setTaskCompleted(success: isFetchingSuccess)
     }
   }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
      //submitBackgroundTasks()
    }
    
    func submitBackgroundTasks() {
      // Declared at the "Permitted background task scheduler identifiers" in info.plist
      let backgroundAppRefreshTaskSchedulerIdentifier = "com.FeedX.backgroundAlerts"
      let timeDelay = 10.0

      do {
        let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskSchedulerIdentifier)
        backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
        try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
        print("Submitted task request")
      } catch {
        print("Failed to submit BGTask")
      }
    }
  }

