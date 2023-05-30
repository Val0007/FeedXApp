//
//  deleteCell.swift
//  FeedX
//
//  Created by Val V on 29/05/23.
//

import UIKit

class deleteCell: UITableViewCell {
    
    private let publisherLabel:UILabel = UILabel()
    private let linkLabel:UILabel = UILabel()
    static let identifier = "deletecellidentifier"
    private let container = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
    }
    
    private func setup(){
        addSubview(container)
        container.layer.cornerRadius = 8
        container.addSubview(publisherLabel)
        container.addSubview(linkLabel)
        publisherLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        publisherLabel.textColor = .gray
        linkLabel.numberOfLines = 0
        linkLabel.adjustsFontSizeToFitWidth = true
        backgroundColor = .black.withAlphaComponent(0.05)
        container.backgroundColor = .white
    }
    
    private func layout(){
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        publisherLabel.anchor(top: container.topAnchor, left: container.leftAnchor,right: container.rightAnchor,paddingTop: 2, paddingLeft: 8)
        publisherLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.22).isActive = true
        linkLabel.anchor(top: publisherLabel.bottomAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 10)
    }
    
    func setupLabels(link:String,pub:String){
        publisherLabel.text = pub
        linkLabel.text = link
    }
    
    
    
}
