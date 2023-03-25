//
//  TabBt.swift
//  FeedX
//
//  Created by Val V on 15/03/23.
//

import UIKit

enum page{
    case Home
    case Options
}

protocol tabButtonClick{
    func changePage(page:page)
}


class TabBt: UIView {

    var img1 = UIImageView(image: UIImage(systemName: "house.fill"))
    let img2 = UIImageView(image: UIImage(systemName: "folder.fill"))
    let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium, scale: .default)
    let imgStack = UIView()
    let backgroundView = UIView()
    var delegate:tabButtonClick?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    
    private func setup(){
        addSubview(imgStack)
        
        imgStack.translatesAutoresizingMaskIntoConstraints = false
        img1.translatesAutoresizingMaskIntoConstraints = false
        img2.translatesAutoresizingMaskIntoConstraints = false
        imgStack.addSubview(img1)
        imgStack.addSubview(img2)
        
        imgStack.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints  = true
        img1.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleHome)))
        img1.isUserInteractionEnabled = true
        img2.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleOption)))
        img2.isUserInteractionEnabled = true
    }
    
    
    private func layout(){
        imgStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        
        backgroundColor = .gray.withAlphaComponent(0.5)
        
        imgStack.layer.cornerRadius = 8
        layer.cornerRadius = 15
        backgroundView.layer.cornerRadius = 10
        
        img1.translatesAutoresizingMaskIntoConstraints = false
        img1.heightAnchor.constraint(equalTo: imgStack.heightAnchor, multiplier: 0.7).isActive = true
        img1.widthAnchor.constraint(equalTo: imgStack.widthAnchor, multiplier: 0.3).isActive = true
        img2.translatesAutoresizingMaskIntoConstraints = false
        img2.heightAnchor.constraint(equalTo: imgStack.heightAnchor, multiplier: 0.7).isActive = true
        img2.widthAnchor.constraint(equalTo: imgStack.widthAnchor, multiplier: 0.3).isActive = true
        img1.centerY(inView: imgStack)
        img2.centerY(inView: imgStack)
        img1.leadingAnchor.constraint(equalTo: imgStack.leadingAnchor,constant: 8).isActive = true
        img2.trailingAnchor.constraint(equalTo: imgStack.trailingAnchor,constant: -8).isActive = true
        backgroundView.frame = img1.frame


    }
    
    private func style(){
        backgroundView.backgroundColor = .white.withAlphaComponent(0.2)
    }
    
    @objc func handleOption(){
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.frame.origin.x = self.img2.frame.origin.x
            self.layoutIfNeeded()
        }completion: { bool in
            if bool{
               self.delegate?.changePage(page: .Options)
            }
        }
        
    }
    
    @objc func handleHome(){
            //touchedButton = button1
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.frame.origin.x -= self.img2.frame.origin.x - 8
                self.layoutIfNeeded()
            }
        delegate?.changePage(page: .Home)
    }
}
