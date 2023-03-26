//
//  FolderBar.swift
//  FeedX
//
//  Created by Val V on 05/10/22.
//

import Foundation

import UIKit

protocol FolderBarDelegate{
    func switchFolder(folder:String)
}

class FolderBar: UIView {
    
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    let underLineView = UIView()
    let folders:[String]
    var selectedView:UIView?
    var delegate:FolderBarDelegate?
    var currentFolder:String?


    init(frame: CGRect,f:[String]) {
        folders = f
        super.init(frame: frame)
        setup()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layout()
        for i in stackView.arrangedSubviews{
            print(i.frame.origin.x)
        }
        print(stackView.frame)
        print(scrollView.frame)
        underLineView.frame.origin.x = stackView.frame.origin.x + 8
        underLineView.frame.origin.y = stackView.frame.origin.y + stackView.frame.height + 10
        underLineView.backgroundColor = .gray
        
        roundCorners([.bottomLeft,.bottomRight], radius: 16)

    }

    @objc func handleTap(_ sender:UITapGestureRecognizer){
        guard let v = sender.view else {return}
        selectedView = v
        print(convert(selectedView?.frame.origin ?? CGPoint(x: 0.0, y: 0.0), from: stackView).x)
        underLineView.frame.origin.x = convert(v.frame.origin, from: stackView).x
        currentFolder = folders[v.tag]
        delegate?.switchFolder(folder:currentFolder ?? "")
    }
    
    func choseView(){
        UIView.animate(withDuration: 0.2) {
            self.underLineView.frame.origin.x = self.convert(self.selectedView?.frame.origin ?? CGPoint(x: 0.0, y: 0.0), from: self.stackView).x
        }
        print(convert(selectedView?.frame.origin ?? CGPoint(x: 0.0, y: 0.0), from: stackView).x)

    }
    
    
    private func setup(){
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        
        for (ind,i) in folders.enumerated() {

            let b = UIView()
            b.tag = ind
            let label = UILabel()
            label.text = i
            b.addSubview(label)
            label.addConstraintsToFillView(b)
            label.textAlignment = .center
            label.textColor = .black
            stackView.addArrangedSubview(b)
            //b.backgroundColor = .darkGray
            let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
            b.addGestureRecognizer(tap)
            b.translatesAutoresizingMaskIntoConstraints = false
            b.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1).isActive = true
            b.layer.cornerRadius = 5
            b.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
        }
        if !folders.isEmpty{
            selectedView = stackView.arrangedSubviews[0]
            choseView()
        }

        
        
        addSubview(scrollView)
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        scrollView.addSubview(stackView)
        stackView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        
        backgroundColor = .systemGray6
        scrollView.backgroundColor = .clear
        stackView.backgroundColor = .clear
        scrollView.delegate = self
        
        stackView.spacing = 10
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
        
        

    }
    
    private func layout(){

        
    }
    
    private func style(){
        underLineView.translatesAutoresizingMaskIntoConstraints = true
        underLineView.frame.size.height = 3
        underLineView.frame.size.width = 100
        addSubview(underLineView)
        scrollView.showsHorizontalScrollIndicator = false
        

        
    }
}

extension FolderBar:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("YES")
        choseView()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        choseView()
    }
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
