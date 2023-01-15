//
//  urlCell.swift
//  FeedX
//
//  Created by Val V on 15/01/23.
//

import UIKit

class urlCell: UITableViewCell {

    static let identifier  = "urlcellidentifier"
    let container = UIView()
    let stack = UIStackView()
    let bottomStack = UIStackView()
    let descLabel  = paddedLabel()
    let pubLabel = UILabel()
    let dateLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         setup()
    }

    override func layoutSubviews() {
        layout()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        addSubview(container)

        container.addSubview(stack)
        container.layer.cornerRadius = 14
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(descLabel)
        stack.addArrangedSubview(bottomStack)
        
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.alignment = .center
        bottomStack.addArrangedSubview(pubLabel)
        bottomStack.addArrangedSubview(dateLabel)
        
        descLabel.backgroundColor = .red
        pubLabel.backgroundColor  = .yellow
        dateLabel.backgroundColor = .blue
        stack.clipsToBounds  = true
        descLabel.clipsToBounds = true
        bottomStack.backgroundColor = .gray
        container.clipsToBounds = true
        descLabel.numberOfLines = 0
        
        
        
        bottomStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bottomStack.isLayoutMarginsRelativeArrangement = true
        
    }
    
    private func layout(){
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 8, paddingBottom: 15, paddingRight: 8)
        container.backgroundColor = .yellow
        
        stack.addConstraintsToFillView(container)
        descLabel.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.80).isActive = true
        bottomStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        
        
        dateLabel.textAlignment = .right
    
        
    }
    
    private func style(){
        
    }
    
    
     func makeCell(item:feedItem){
         let desc = item.feedItemDesc.trimmingCharacters(in: .whitespacesAndNewlines)
        descLabel.text = desc
        pubLabel.text = item.feedPublisher
        dateLabel.text  = item.feedItemDate
    }
    
}
