//
//  AddFolderVC.swift
//  FeedX
//
//  Created by Val V on 10/01/23.
//

import UIKit

class AddFolderVC: UIViewController {
    
    let tf:UITextField = PaddedTf()
    let submitBtn = UIButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.title = "Add New Folder"
        
        setup()
        layout()
        style()

    }
    
    
    private func layout(){
        tf.centerX(inView: self.view)
        tf.anchor(top: view.topAnchor,paddingTop: view.frame.height * 0.35,width: view.frame.width * 0.8, height: view.frame.height * 0.08)
        
        submitBtn.centerX(inView: self.view)
        submitBtn.anchor(top: tf.bottomAnchor,paddingTop: view.frame.height * 0.1,width: view.frame.width * 0.8, height: view.frame.height * 0.08)
        
        
    }
    
    private func setup(){
        view.addSubview(tf)
        tf.placeholder = "Enter Folder name"
        tf.becomeFirstResponder()
        
        view.addSubview(submitBtn)
        let attrString = NSAttributedString(string: "Create Folder", attributes: [.font:UIFont.boldSystemFont(ofSize: 20),.foregroundColor:UIColor.white])
        submitBtn.setAttributedTitle(attrString, for: .normal)
        submitBtn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    private func style(){
        tf.font = .boldSystemFont(ofSize: 20)
        tf.layer.borderWidth = 0.8
        tf.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        tf.layer.cornerRadius = 8
        
        submitBtn.backgroundColor = .link
        submitBtn.layer.cornerRadius = 8
    }
    

    @objc func handleSubmit(){
        guard let folderName = tf.text,!folderName.isEmpty else {return}
        SqlDB.shared.insertElement(type: .Folders(folderName)) { success in
            if success{
                SqlDB.shared.getFolders()
                navigationController?.popViewController(animated: true)
            }
            else{
                
            }
        }
    }


}
