//
//  folderNameCell.swift
//  FeedX
//
//  Created by Val V on 19/06/23.
//

import UIKit

class folderNameCell: UICollectionViewCell {
    let nameLabel:UILabel = paddedLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(nameLabel)
        nameLabel.addConstraintsToFillView(self)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        layer.cornerRadius = 4
    }
    
    func update(label:String){
        nameLabel.text = label
    }
    
    
    func toggle(value:Bool){
        if value{
            nameLabel.textColor = .white
            backgroundColor = .black
            nameLabel.font = .systemFont(ofSize: 19, weight: .bold)
        }
        else{
            nameLabel.textColor = .black
            //backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
            backgroundColor = .black.withAlphaComponent(0.05)
            nameLabel.font = .systemFont(ofSize: 16, weight: .light)
        }
    }
}
