//
//  SideScreenAnimator.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import Foundation
import UIKit

class SlideInPresentationAnimator: NSObject {

  let direction: PresentationDirection

  //2
  let isPresentation: Bool
  
  //3
  // MARK: - Initializers
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
  
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
      return 0.4
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    
    //if this is a presentation, the method asks the transitionContext for the view controller associated with .to
    //to -> presented vc
    //from -> parent vc
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
    
    guard let controller = transitionContext.viewController(forKey: key)
      else { return }
      //print(controller)
    
    // 2
      //adding our presentationController
    if isPresentation {
        //print("containerView frame \(transitionContext.containerView.frame)") -> full screen
      transitionContext.containerView.addSubview(controller.view)
    }

    // 3
    //transitionContext for the view’s frame when it’s presented after adding to the view hierarchy
    let presentedFrame = transitionContext.finalFrame(for: controller)
      //frame including origin x and origin y obtained from values set in presentationController
    //true frame of presented VC acquired from presententationController
    //we just use these values to animate in animator
      
    var dismissedFrame = presentedFrame
    
    switch direction {
    case .left:
      dismissedFrame.origin.x = -presentedFrame.width
    case .right:
      dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
    case .top:
      dismissedFrame.origin.y = -presentedFrame.height
    case .bottom:
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
    }
      
    //Traditionally animation occurs from y = transitionContext.containerView.frame.size.height to y =0
    //we are modifying that and doing whatever animation we want
    
    
    
    // 4
    //if presenting we want to fo from presentedFrame -> dismissedFrame
    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame
      
    // 5
    //we are only animating the presentedContentView'sFrame and not actually removing or adding it
    let animationDuration = transitionDuration(using: transitionContext)
    
      //setting the starting point with inital frame
      controller.view.frame = initialFrame
    
      UIView.animate(
      withDuration: animationDuration,
      animations: {
        controller.view.frame = finalFrame
    }, completion: { finished in
      if !self.isPresentation {
        //removing it from superView - dont want unwanted view to be in memory
        controller.view.removeFromSuperview()
      }
      transitionContext.completeTransition(finished) //bool
    })
  }
}


