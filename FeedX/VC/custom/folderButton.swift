//
//  folderButton.swift
//  FeedX
//
//  Created by Val V on 27/06/23.
//

import UIKit

class folderButton: UIView {

    let name = UILabel()
    let img:UIImageView
    let container = UIView()
    
    init(name:String,img:UIImage) {
        self.name.text = name
        self.img = UIImageView(image: img)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(container)
        container.addConstraintsToFillView(self)
        container.addSubview(img)
        container.addSubview(name)
        img.centerY(inView: container)
        img.anchor(left: container.leftAnchor,paddingLeft: 8)
        img.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.15).isActive = true
        img.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
        name.centerY(inView: container)
        name.anchor(left: img.rightAnchor, right: container.rightAnchor,paddingLeft: 10,paddingRight: 4)
//        container.layer.borderWidth = 1
//        container.layer.borderColor = UIColor.white.cgColor
        name.textAlignment = .center
        name.font = .systemFont(ofSize: 18, weight: .semibold)
        img.tintColor = .white
        name.textColor = .white
        backgroundColor = .black
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 4
        //container.makeBorderWithCornerRadius(radius: 8, borderColor: .black, borderWidth: 0.8)
    }

}


extension UIView{

    func makeBorderWithCornerRadius(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let rect = self.bounds

        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))

        // Create the shape layer and set its path
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path  = maskPath.cgPath

        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer

        // Create path for border
        let borderPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: .allCorners,
                                      cornerRadii: CGSize(width: radius, height: radius))

        // Create the shape layer and set its path
        let borderLayer = CAShapeLayer()

        borderLayer.frame       = rect
        borderLayer.path        = borderPath.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor   = UIColor.clear.cgColor
        borderLayer.lineWidth   = borderWidth * UIScreen.main.scale

        //Add this layer to give border.
        self.layer.addSublayer(borderLayer)
    }

}
