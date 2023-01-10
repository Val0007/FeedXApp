//
//  SlideScreenTransitionDelegate.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import Foundation
import UIKit

enum PresentationDirection {
  case left
  case top
  case right
  case bottom
}

class SlideInPresentationManager: NSObject {
  
  var direction: PresentationDirection = .left


}

extension SlideInPresentationManager:UIViewControllerTransitioningDelegate{
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    print("IS HAPPENING")
    let presentationController = SlideInPresentationController(
      presentedViewController: presented,
      presentingViewController: presenting,
      direction: direction
    )
    return presentationController
  }
  
  
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: false)
  }
  
}
