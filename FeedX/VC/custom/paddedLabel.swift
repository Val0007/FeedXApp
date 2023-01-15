//
//  paddedLabel.swift
//  FeedX
//
//  Created by Val V on 15/01/23.
//

import Foundation
import UIKit


class paddedLabel: UILabel {

 let topInset = CGFloat(5.0), bottomInset = CGFloat(5.0), leftInset = CGFloat(8.0), rightInset = CGFloat(8.0)

    override func drawText(in rect: CGRect) {

  let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))


 }
    
    override var intrinsicContentSize: CGSize{
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
     intrinsicSuperViewContentSize.height += topInset + bottomInset
     intrinsicSuperViewContentSize.width += leftInset + rightInset
     return intrinsicSuperViewContentSize
    }
    
}
