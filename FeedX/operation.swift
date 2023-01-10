//
//  operation.swift
//  FeedX
//
//  Created by Val V on 27/11/22.
//

import Foundation

class OP: Operation {
    
    override func main() {
        print("OPERATION RAN")
        NotificationManager().sendNotification2()
        UserDefaults.standard.set(true, forKey: "backk")
    }
}
