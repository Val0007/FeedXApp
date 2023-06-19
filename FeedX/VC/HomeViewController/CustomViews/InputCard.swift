//
//  InputCard.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import Foundation

import UIKit
import DropDown

protocol InputDelegate{
    func addurl(link:InsertType)
}

class InputCard: UIView, UITextViewDelegate {
    
    let container = UIView()
    let foldername = UIView()
    let urlInput = UITextView()
    let publisherInput = PaddedTf()
    let button = UIButton()
    let containerPadding:CGFloat = 8.0
    let dropDown = DropDown()
    let foldernameText = paddedLabel()
    let folders:[String]
    var delegate:InputDelegate?
    var urlInputHeight:NSLayoutConstraint?
    var changeHeight:Bool = false
     init(frame: CGRect,f:[String]) {
        folders = f
        super.init(frame: frame)
        setup()
        style()


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //why?
    override func layoutSubviews() {
        layout()

    }
    
    
    @objc func handleFolder(){
        dropDown.show()
    }
    
    @objc func handleAdd(){
        guard let pbName = publisherInput.text, !pbName.isEmpty else {return}
       guard let u = urlInput.text,!u.isEmpty else {return}
        guard let f = foldernameText.text else {return}
        delegate?.addurl(link: .Link(f, pbName, u))
        //animation()
    }
    
    private func setup(){
        backgroundColor = .gray.withAlphaComponent(0.3)
        
        addSubview(urlInput)
        urlInput.delegate  = self
        addSubview(button)
        addSubview(foldername)
        addSubview(publisherInput)
        publisherInput.delegate = self
        foldername.addSubview(foldernameText)
        
        dropDown.direction = .bottom
        dropDown.dataSource = folders
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.foldernameText.text = item
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFolder))
        foldername.addGestureRecognizer(tap)
        

        
    }
    private func style(){
        //container.backgroundColor = .white
        
        foldername.backgroundColor  = .systemGray6
        foldername.layer.borderWidth = 0.5
        foldername.layer.borderColor = UIColor.black.cgColor
        foldername.layer.cornerRadius = 5
        foldernameText.textColor = .black
        foldernameText.font = UIFont.systemFont(ofSize: 18)
        foldernameText.text = "Click to select"
        foldernameText.backgroundColor = .white
        foldername.layer.masksToBounds = true


        urlInput.backgroundColor  = .white
        urlInput.layer.borderWidth = 0.5
        urlInput.layer.borderColor = UIColor.black.cgColor
        urlInput.font = UIFont.systemFont(ofSize: 18)
        urlInput.layer.cornerRadius = 5
        urlInput.text = "Enter URL"
        
        publisherInput.backgroundColor  = .white
        publisherInput.layer.borderWidth = 0.5
        publisherInput.layer.borderColor = UIColor.black.cgColor
        publisherInput.placeholder  = "Publisher Name"
        publisherInput.font = UIFont.systemFont(ofSize: 18)
        publisherInput.layer.cornerRadius = 5

        
        button.backgroundColor  = .twitterBlue
        button.layer.cornerRadius = containerPadding
        button.setTitle("Add URL", for: .normal)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
 
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 16)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        DropDown.appearance().setupCornerRadius(10)

        
    }
    private func layout(){
        
        layoutIfNeeded()
        foldername.anchor(top: topAnchor, left: leftAnchor,right: rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingRight: containerPadding,height: frame.height * 0.18)
        foldernameText.addConstraintsToFillView(foldername)
        foldername.backgroundColor = .red
        foldernameText.textAlignment = .left
         
        urlInput.anchor(top: foldername.bottomAnchor, left: leftAnchor,right: rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingRight: containerPadding)



        
        publisherInput.anchor(top: urlInput.bottomAnchor, left: leftAnchor,right: rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingRight: containerPadding,height: frame.height * 0.18)
        
        button.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingBottom: containerPadding * 2,paddingRight: containerPadding,height: frame.height * 0.2)
        
        if !changeHeight{
            urlInputHeight?.isActive = false
            urlInputHeight = urlInput.heightAnchor.constraint(equalToConstant: frame.height * 0.18)
            urlInputHeight?.isActive = true
        }
        else{
            urlInputHeight?.isActive = false
            urlInputHeight = urlInput.heightAnchor.constraint(equalToConstant: frame.height * 0.25)
            urlInputHeight?.isActive = true
            publisherInput.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14).isActive = true
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.16).isActive = true

        }
        
        layoutIfNeeded()
        dropDown.anchorView = foldername
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
       
        
    }

    
    
}


extension InputCard:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        urlInput.resignFirstResponder()
        publisherInput.resignFirstResponder()
        return true
    }
    
    
    
    //urlinput
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            urlInput.resignFirstResponder()
            publisherInput.resignFirstResponder()
            return false
        }
        
        if text == UIPasteboard.general.string{
            urlInputHeight?.isActive  = false
            print( UIPasteboard.general.string!)
            let h = UIPasteboard.general.string!.height(withConstrainedWidth: urlInput.frame.width)
            print("height is ",h,urlInputHeight?.constant)
            if h > urlInputHeight!.constant {
                let diff = h - urlInputHeight!.constant
                print("change height")
                changeHeight = true
                layoutIfNeeded()
            }
        }

         return true
    }
    
    
    
    
    func getHeight(text: String) -> CGFloat
   {
       let txtField = UITextField(frame: .zero)
       txtField.text = text
       txtField.sizeToFit()
       return txtField.frame.size.height
   }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont = .systemFont(ofSize: 16, weight: .regular)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

}

