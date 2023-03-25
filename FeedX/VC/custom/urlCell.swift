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
    let separator = UIView()
    
    
    func getFrame()->CGRect{
        return container.frame
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        style()
//        self.setRemoveSwipeAction()
    }

    
    override func layoutIfNeeded() {
//        self.setRemoveSwipeAction()

    }
    

    
    override func prepareForReuse() {
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        //addSubview(separator)
        addSubview(container)
        container.addSubview(separator)
        container.backgroundColor = .none
        container.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        container.layer.borderWidth = 0.8
        container.addSubview(stack)
        container.layer.cornerRadius = 2
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(descLabel)
        stack.addArrangedSubview(bottomStack)
        
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.alignment = .center
        bottomStack.addArrangedSubview(pubLabel)
        bottomStack.addArrangedSubview(dateLabel)
        
        //descLabel.backgroundColor = .red
        //pubLabel.backgroundColor  = .yellow
        //dateLabel.backgroundColor = .blue
        stack.clipsToBounds  = true
        descLabel.clipsToBounds = true
        //bottomStack.backgroundColor = .gray
        container.clipsToBounds = true
        descLabel.numberOfLines = 0
        
        
        
        bottomStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bottomStack.isLayoutMarginsRelativeArrangement = true
        
    }
    
    private func layout(){
        container.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 8, paddingBottom: 15, paddingRight: 8)
        
        stack.addConstraintsToFillView(container)
        descLabel.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.80).isActive = true
        bottomStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2).isActive = true
        
        
        dateLabel.textAlignment = .right
        descLabel.numberOfLines = 0
        descLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        pubLabel.font = UIFont.systemFont(ofSize: 10)
        
        separator.anchor(left:container.leftAnchor,bottom: bottomStack.topAnchor,right: container.rightAnchor,height: 1)
        separator.backgroundColor = .black.withAlphaComponent(0.3)

    }
    
    private func style(){


    }
    
    
     func makeCell(item:feedItem){
         let desc = item.feedItemTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        descLabel.text = desc
        pubLabel.text = item.feedPublisher
         dateLabel.text  = parseDate(dateTobeparsed: item.feedItemDate)

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
