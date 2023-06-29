//
//  articleCell.swift
//  FeedX
//
//  Created by Val V on 20/06/23.
//

import UIKit

class articleCell: UITableViewCell {

    let container = UIView()
    let topView = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let pubLabel = UILabel()
    let timeLabel = UILabel()
    var item:feedItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        cellstyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        addSubview(container)
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 2, paddingBottom: 4, paddingRight: 2)
        backgroundColor = .clear
//        container.backgroundColor  = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.00)
        container.backgroundColor = .white
        
        container.addSubview(topView)
        container.addSubview(titleLabel)
        container.addSubview(descLabel)
        
        topView.anchor(top: container.topAnchor, left: container.leftAnchor,right: container.rightAnchor)
        topView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1).isActive = true
        
        titleLabel.anchor(top: topView.bottomAnchor, left: container.leftAnchor, right: container.rightAnchor,paddingTop: 10)
        titleLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.4).isActive = true
        
        descLabel.anchor(top: titleLabel.bottomAnchor, left: container.leftAnchor,bottom: container.bottomAnchor ,right: container.rightAnchor,paddingTop: 10)


        
        topView.addSubview(pubLabel)
        topView.addSubview(timeLabel)
        
        pubLabel.anchor(top: topView.topAnchor, left: topView.leftAnchor, bottom: topView.bottomAnchor)
        pubLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.5).isActive = true
        timeLabel.anchor(top: topView.topAnchor, left: pubLabel.rightAnchor, bottom: topView.bottomAnchor, right: topView.rightAnchor)
    }
    
    func cellstyle(){
        titleLabel.font = .systemFont(ofSize: 18, weight: .black)
        descLabel.font = .systemFont(ofSize: 14, weight: .light)
        descLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        descLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 12, weight: .light)
        pubLabel.font = .systemFont(ofSize: 10, weight: .heavy)
        timeLabel.textAlignment = .right
    }
    
    func update(item:feedItem){
        self.item = item
        titleLabel.text = item.feedItemTitle
        descLabel.text = item.feedItemDesc
        pubLabel.text = item.feedPublisher
        timeLabel.text = parseDate(dateTobeparsed: item.feedItemDate)
    }

    
    func parseDate(dateTobeparsed:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: dateTobeparsed) {
            dateFormatter.dateFormat = "E,dd MMMM,HH:mm"
            let formattedDate = dateFormatter.string(from: date)
            print(formattedDate) // "Wed,08 March,19:58"
            return formattedDate
        }
        return ""
    }
}
