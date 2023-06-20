//
//  BottomBar.swift
//  FeedX
//
//  Created by Val V on 19/06/23.
//

import UIKit

enum page{
    case Home
    case Options
}

protocol tabButtonClick{
    func changePage(page:page)
    func pubFilter(pubName:String)
    func pubAll()
}

class BottomBar: UIView {
    
    let stackview = UIStackView()
    let homeLabel = UIButton()
    let foldersLabel = paddedLabel()
    let selectorView = UIView()
    var leftAnchorForSelector:NSLayoutConstraint?
    var delegate:tabButtonClick?
    var filterMenu:UIMenu?
    var pubNames:[String] = []


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
        stackview.addSubview(selectorView)
        stackview.addArrangedSubview(homeLabel)
        stackview.addArrangedSubview(foldersLabel)
        homeLabel.setTitleColor(.black, for: .normal)
        foldersLabel.textColor = .black
        foldersLabel.text = "Folders"
        homeLabel.setAttributedTitle(buttonTitleAttr(), for: .normal)
//        homeLabel.textAlignment = .center
        foldersLabel.textAlignment = .center
//        homeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        foldersLabel.font = .systemFont(ofSize: 14, weight: .bold)
        stackview.isUserInteractionEnabled = true
        foldersLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFolder(_:))))
        homeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHome(_:))))
        foldersLabel.isUserInteractionEnabled = true
        homeLabel.isUserInteractionEnabled = true
        stackview.backgroundColor = .gray.withAlphaComponent(0.5)
        stackview.layer.cornerRadius = 4
        selectorView.layer.cornerRadius = 4
        
        stackview.centerY(inView: self)
        stackview.centerX(inView: self)
        stackview.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        stackview.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        selectorView.heightAnchor.constraint(equalTo: homeLabel.heightAnchor, multiplier: 1).isActive =  true
        selectorView.widthAnchor.constraint(equalTo: homeLabel.widthAnchor, multiplier: 1).isActive = true
        selectorView.backgroundColor = .black.withAlphaComponent(0.1)
        leftAnchorForSelector = selectorView.leftAnchor.constraint(equalTo: homeLabel.leftAnchor)
        leftAnchorForSelector?.isActive = true
        selectorView.centerY(inView: homeLabel)
        handleHome()
    
        
        filterMenu =   UIMenu(title: "Filter", image: nil, identifier: nil, options: [], children: generateMenuOptions())
        homeLabel.menu = filterMenu
        
    }
    
    @objc func handleFolder(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.5) {
            self.leftAnchorForSelector?.isActive = false
            self.leftAnchorForSelector = self.selectorView.leftAnchor.constraint(equalTo: self.foldersLabel.leftAnchor)
            self.leftAnchorForSelector?.isActive = true
            self.foldersLabel.textColor = .white
            self.homeLabel.setTitleColor(.black, for: .normal)
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
            self.homeLabel.setTitleColor(.white, for: .normal)
            self.layoutIfNeeded()
            self.delegate?.changePage(page: .Home)
            print(self.pubNames)
        }
        
    }
    
    
    private func generateMenuOptions()->[UIAction]{
        var actions:[UIAction] = []
        print(pubNames)
        for item in pubNames {
            print("IIETM")
            let a = UIAction(title: item, image: nil, handler: { (_) in
                self.delegate?.pubFilter(pubName: item)
                    })
            actions.append(a)
        }
        let a = UIAction(title: "Show All", image: nil, handler: { (_) in
            self.delegate?.pubAll()
                })
        actions.append(a)
        return actions
    }
    
    func changeMenu(){
        homeLabel.menu = filterMenu?.replacingChildren(generateMenuOptions())
    }
    
    func buttonTitleAttr()->NSAttributedString{
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        let attributedTitle = NSAttributedString(string: "Home", attributes: attributes)
        return attributedTitle
    }

}
