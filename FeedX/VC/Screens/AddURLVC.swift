//
//  AddURLVC.swift
//  FeedX
//
//  Created by Val V on 13/01/23.
//

import UIKit

protocol AddDelegate{
    func refreshFolder()
    func refreshUrlFeed()
}

class AddURLVC: UIViewController {
    
    var inputCard:InputCard?
    var delegate:AddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let folders = SqlDB.shared.getFolders()
        inputCard  = InputCard(frame: .zero,f: folders)
        inputCard?.delegate = self
        setup()
        layout()
        style()
    }
    
    

    private func setup(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.title = "Add New URL"
        
        guard let inputCard = inputCard else {
            return
        }
        view.addSubview(inputCard)
    }
    
    
    private func layout(){
        guard let inputCard = inputCard else {
            return
        }
        inputCard.centerX(inView: self.view)
        inputCard.anchor(top: view.topAnchor,paddingTop: view.frame.height * 0.35,width: view.frame.width * 0.8, height: view.frame.height * 0.45)
    }
    
    
    private func style(){
        view.backgroundColor = .white
    }

}


extension AddURLVC:InputDelegate{
    func addurl(link: InsertType) {
        SqlDB.shared.insertElement(type: link) { success in
            if success{
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
