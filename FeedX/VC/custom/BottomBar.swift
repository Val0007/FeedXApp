//
//  BottomBar.swift
//  FeedX
//
//  Created by Val V on 19/06/23.
//

import UIKit

class BottomBar: UIView {
    
    let stackview = UIStackView()
    let homeLabel = paddedLabel()
    let foldersLabel = paddedLabel()
    let selectorView = UIView()
    var leftAnchorForSelector:NSLayoutConstraint?
    var delegate:tabButtonClick?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(stackview)
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.addArrangedSubview(homeLabel)
        stackview.addArrangedSubview(foldersLabel)
        homeLabel.text = "Home"
        homeLabel.textColor = .black
        foldersLabel.textColor = .black
        foldersLabel.text = "Folders"
        homeLabel.textAlignment = .center
        foldersLabel.textAlignment = .center
        homeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        foldersLabel.font = .systemFont(ofSize: 16, weight: .bold)
        stackview.isUserInteractionEnabled = true
        foldersLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFolder(_:))))
        homeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHome(_:))))
        foldersLabel.isUserInteractionEnabled = true
        homeLabel.isUserInteractionEnabled = true
        stackview.backgroundColor = .gray.withAlphaComponent(0.8)
        stackview.layer.cornerRadius = 4
        selectorView.layer.cornerRadius = 4
        
        stackview.centerY(inView: self)
        stackview.centerX(inView: self)
        stackview.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        stackview.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        stackview.addSubview(selectorView)
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        selectorView.heightAnchor.constraint(equalTo: homeLabel.heightAnchor, multiplier: 1).isActive =  true
        selectorView.widthAnchor.constraint(equalTo: homeLabel.widthAnchor, multiplier: 1).isActive = true
        selectorView.backgroundColor = .black.withAlphaComponent(0.1)
        leftAnchorForSelector = selectorView.leftAnchor.constraint(equalTo: homeLabel.leftAnchor)
        leftAnchorForSelector?.isActive = true
        selectorView.centerY(inView: homeLabel)
        handleHome()
    
    }
    
    @objc func handleFolder(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.5) {
            self.leftAnchorForSelector?.isActive = false
            self.leftAnchorForSelector = self.selectorView.leftAnchor.constraint(equalTo: self.foldersLabel.leftAnchor)
            self.leftAnchorForSelector?.isActive = true
            self.foldersLabel.textColor = .white
            self.homeLabel.textColor = .black
            self.layoutIfNeeded()
            self.delegate?.changePage(page: .Options)
        }
        
    }
    
    @objc func handleHome(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.5) {
            self.leftAnchorForSelector?.isActive = false
            self.leftAnchorForSelector = self.selectorView.leftAnchor.constraint(equalTo: self.homeLabel.leftAnchor)
            self.leftAnchorForSelector?.isActive = true
            self.foldersLabel.textColor = .black
            self.homeLabel.textColor = .white
            self.layoutIfNeeded()
            self.delegate?.changePage(page: .Home)
        }
        
    }

}
