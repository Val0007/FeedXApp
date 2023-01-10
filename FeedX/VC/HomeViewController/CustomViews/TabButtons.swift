//
//  TabButtons.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import UIKit

enum page{
    case Home
    case Options
}

protocol tabButtonClick{
    func changePage(page:page)
}

class TabButtons: UIView {
    
    lazy var separator:UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    let button1 = UIStackView()
    let button2 = UIStackView()
    let container = UIStackView()
    let img1 = UIImageView(image: UIImage(systemName: "house.fill"))
    let img2 = UIImageView(image: UIImage(systemName: "folder.fill"))
    let label1 = UILabel()
    let label2 = UILabel()
    var delegate:tabButtonClick?
    var touchedButton:UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        layout()
        touchedButton = button1
        touchedButton?.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        makeStack()
        backgroundColor = .gray.withAlphaComponent(0.2)
        layer.cornerRadius = 10
        addSubview(container)
        container.distribution = .fill
        button1.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.495).isActive = true
        button2.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.495).isActive = true
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    private func makeStack(){
        button1.translatesAutoresizingMaskIntoConstraints  = false
        img1.translatesAutoresizingMaskIntoConstraints  = false
        label1.translatesAutoresizingMaskIntoConstraints  = false
        button1.addArrangedSubview(img1)
        button1.addArrangedSubview(label1)
        label1.textAlignment = .center
        label1.text = "Home"
        label1.font = UIFont.systemFont(ofSize: 20)
        button1.alignment = .center
        button1.distribution = .fill
        img1.widthAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 0.3).isActive = true
        label1.widthAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 0.7).isActive = true
        container.addArrangedSubview(button1)
        button1.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleHome)))
        
        container.addArrangedSubview(separator)
        
        button2.translatesAutoresizingMaskIntoConstraints  = false
        img2.translatesAutoresizingMaskIntoConstraints  = false
        label2.translatesAutoresizingMaskIntoConstraints  = false
        button2.addArrangedSubview(img2)
        button2.addArrangedSubview(label2)
        label2.textAlignment = .center
        label2.text = "Folders"
        label2.font = UIFont.systemFont(ofSize: 20)
        button2.alignment = .center
        button2.distribution = .fill
        img2.widthAnchor.constraint(equalTo: button2.widthAnchor, multiplier: 0.3).isActive = true
        label2.widthAnchor.constraint(equalTo: button2.widthAnchor, multiplier: 0.7).isActive = true
        container.addArrangedSubview(button2)
        button2.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleOption)))

        
    }
    
    @objc func handleHome(){
        touchedButton?.backgroundColor = .clear
        touchedButton = button1
        touchedButton?.backgroundColor = .gray
        delegate?.changePage(page: .Home)
    }
    
    @objc func handleOption(){
        touchedButton?.backgroundColor = .clear
        touchedButton = button2
        touchedButton?.backgroundColor = .gray
        delegate?.changePage(page: .Options)
    }
}
