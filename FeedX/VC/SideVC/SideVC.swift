//
//  SideVC.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import UIKit

protocol SideVCPush{
    func pushVC(type:types)
    func willpop()
}

enum types:String,CaseIterable{
    case anf = "Add New Folder"
    case anu = "Add New Url"
    case df = "Delete Folder"
    case du = "Delete Url"
    case f = "Favourites"
    case rl = "Read Later"
}

class SideVC: UIViewController {
    
    var delegate:SideVCPush?
    
    let mainStack = UIStackView()
    var previousBtn:folderButton?
    
    let options:[UIImage:types] = [
        UIImage(systemName: "folder.badge.plus")!:.anf,
        UIImage(systemName: "doc.fill.badge.plus")!:.anu,
        UIImage(systemName: "folder.badge.minus")!:.df,
        UIImage(systemName: "doc.badge.gearshape.fill")!:.du,
        UIImage(systemName: "suit.heart.fill")!:.f,
        UIImage(systemName: "bag.fill")!:.rl,
    ]
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.willpop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        layout()
//        style()
        }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        //SETUP CALLED HERE AND NOT VIEWDIDLOAD AS DUE TO PRESENTATION CONTROLLER GIVING NEW FRAME SIZES ONLY AFTER SOME TIME
        setup()
        //why?
//        for stack in mainStack.arrangedSubviews{
//            let bottomLine = CALayer()
//            bottomLine.frame = CGRect(x: 0, y: stack.frame.size.height - 10, width: stack.frame.size.width, height: 1)
//            bottomLine.backgroundColor = UIColor.black.cgColor
//            stack.layer.addSublayer(bottomLine)
//            print(stack.frame)
//        }
        
    }
        
    private func layout(){
        view.addSubview(mainStack)
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
//        for (ind,i) in types.allCases.enumerated(){
//            let stack = UIStackView()
//            //let imgV = UIImageView(image: options.key(from: i))
//            let label = UILabel()
//            label.font = .systemFont(ofSize: 23)
//            label.attributedText = setCharacterSpacig(string: i.rawValue)
//            label.minimumScaleFactor = 0.6
//            label.adjustsFontSizeToFitWidth = true
//            stack.addArrangedSubview(imgV)
//            stack.addArrangedSubview(label)
//            stack.distribution = .fill
//            imgV.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.12).isActive = true
//            label.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.82).isActive = true
//            imgV.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.12).isActive = true
//            label.textAlignment = .left
//            mainStack.addArrangedSubview(stack)
//            stack.alignment = .center
//            stack.tag = ind
//            stack.clipsToBounds = true
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :))))
//
//
//        }
    }
    
    private func style(){
        view.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        mainStack.spacing = 20
        mainStack.clipsToBounds = true
        mainStack.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 80, paddingLeft: 24,paddingRight: 24,height: view.frame.height * 0.5)
        
    }
    
    private func setup(){
        view.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        for (ind,i) in types.allCases.enumerated(){
            guard let uiimg = options.someKey(forValue: i) else {return}
            let btn  = folderButton(name: types.allCases[ind].rawValue, img:uiimg)
            btn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(btn)
            print(ind)
            let base = view.frame.height * CGFloat(0.2)
            let height = view.frame.height * 0.06
            if ind == 0{
                btn.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: base, paddingLeft: 15, paddingRight: 15,height: height)
            }
            else{
                if let previousBtn = previousBtn {
                    btn.anchor(top: previousBtn.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingRight: 15,height: height)
                }
            }
            btn.tag = ind
            btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :))))
            previousBtn = btn
        }
        
        
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if let v = sender.view{
            let tag = v.tag
            let op = types.allCases[tag]
            print(op.rawValue)
            dismiss(animated: true, completion: nil)
            delegate?.pushVC(type: op)
        }

    }
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

func setCharacterSpacig(string:String) -> NSMutableAttributedString {

    let attributedStr = NSMutableAttributedString(string: string)
    attributedStr.addAttribute(NSAttributedString.Key.kern, value: 1.25, range: NSMakeRange(0, attributedStr.length))
    return attributedStr
}

extension UILabel {
    var isTruncated: Bool {
        print(self.bounds.width)
        guard let labelText = text as? NSString else {
            return false
        }
        let size = labelText.size(withAttributes: [NSAttributedString.Key.font: font])
        return size.width > self.bounds.width
    }
}
