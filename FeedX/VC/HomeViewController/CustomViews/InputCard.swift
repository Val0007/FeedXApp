//
//  InputCard.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import Foundation

import UIKit
import DropDown

class InputCard: UIViewController {
    
    let container = UIView()
    let foldername = UIView()
    let urlInput = UITextField()
    let button = UIButton()
    let containerPadding:CGFloat = 8.0
    let dropDown = DropDown()
    let foldernameText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        style()

    }
    
    override func viewDidLayoutSubviews() {

        //animation()
        
    }
    
    
    @objc func handleFolder(){
        dropDown.show()
    }
    
    @objc func handleAdd(){
        animation()
    }
    
    private func setup(){
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        
        
        view.addSubview(container)
        container.addSubview(urlInput)
        container.addSubview(button)
        
        container.addSubview(foldername)
        foldername.addSubview(foldernameText)
        dropDown.direction = .bottom
        dropDown.dataSource = ["Car", "Motorcycle", "Truck","Car", "Motorcycle", "Truck"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.foldernameText.text = item
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFolder))
        foldername.addGestureRecognizer(tap)
        
    }
    private func style(){
        container.backgroundColor = .white
        
        foldername.backgroundColor  = .systemGray6
        foldername.layer.borderWidth = 0.5
        foldername.layer.borderColor = UIColor.black.cgColor
        foldername.layer.cornerRadius = 5
        foldernameText.textColor = .black
        foldernameText.font = UIFont.systemFont(ofSize: 18)
        foldernameText.text = "Click to select"



        urlInput.backgroundColor  = .systemGray6
        urlInput.layer.borderWidth = 0.5
        urlInput.layer.borderColor = UIColor.black.cgColor
        urlInput.placeholder  = "Paste URL"
        urlInput.font = UIFont.systemFont(ofSize: 18)
        urlInput.layer.cornerRadius = 5

        
        button.backgroundColor  = .twitterBlue
        button.layer.cornerRadius = containerPadding
        button.setTitle("Add URL", for: .normal)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)

        
 

        
    }
    private func layout(){
        container.anchor(left:view.safeAreaLayoutGuide.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor,paddingLeft: 8,paddingBottom: containerPadding,paddingRight: 8,height: view.frame.height * 0.4)
        
        
        view.layoutIfNeeded()
        foldername.anchor(top: container.topAnchor, left: container.leftAnchor,right: container.rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingRight: containerPadding,height: container.frame.height * 0.18)
        foldernameText.addConstraintsToFillView(foldername)
        foldernameText.textAlignment = .left
        
        urlInput.anchor(top: foldername.bottomAnchor, left: container.leftAnchor,right: container.rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingRight: containerPadding,height: container.frame.height * 0.18)
        
        button.anchor(left: container.leftAnchor,bottom: container.bottomAnchor,right: container.rightAnchor, paddingTop: containerPadding*3, paddingLeft: containerPadding, paddingBottom: containerPadding * 2,paddingRight: containerPadding,height: container.frame.height * 0.2)
        
        view.layoutIfNeeded()
        dropDown.anchorView = foldername
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
       
        
    }

    
    
}


//ANIMATION
extension InputCard{
    
    func animation(){
        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clear.cgColor

        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0,y: container.frame.height/2))
        path2.addLine(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: container.frame.width, y: 0))
        path2.addLine(to: CGPoint(x: container.frame.width, y: container.frame.height))
        path2.addLine(to: CGPoint(x: 0, y: container.frame.height))
        path2.close()
        
        layer.path = path2.cgPath

        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = 1
        lineWidthAnimation.toValue = 3
        lineWidthAnimation.duration = 0.2
        lineWidthAnimation.repeatCount = .infinity
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.repeatCount = .infinity

        animation.duration = 5.0
        fadeAnimation.duration = 5.1
        
//        let movingLayer = CAShapeLayer()
//        movingLayer.fillColor = UIColor.green.cgColor
//        movingLayer.path = path2.cgPath
//        movingLayer.bounds = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
//        movingLayer.masksToBounds = true
//
//        let manimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
//        manimation.duration = 5
//        manimation.repeatCount = MAXFLOAT
//        manimation.path = path2.cgPath
//        movingLayer.add(manimation,forKey: "ddds")
    

        layer.add(animation, forKey: "myStroke")
        layer.add(fadeAnimation, forKey: "i")
        layer.add(lineWidthAnimation,forKey: "")
        self.container.layer.addSublayer(layer)
        //self.container.layer.addSublayer(movingLayer)
    }

}
