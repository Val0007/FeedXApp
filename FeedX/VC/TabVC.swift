//
//  TabVC.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import UIKit

class TabVC: UITabBarController,UITabBarControllerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    
    func prepare(){
        let vc1 = UINavigationController(rootViewController: ViewController())
        vc1.tabBarItem.title = "Home"
        let vc2 = UINavigationController(rootViewController: SideVC())
        vc2.tabBarItem.title = "Options"
        viewControllers = [vc1,vc2]
        
    }
    

}
