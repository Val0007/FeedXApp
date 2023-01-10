//
//  SideScreenPresentationController.swift
//  FeedX
//
//  Created by Val V on 09/01/23.
//

import Foundation
import UIKit

class SlideInPresentationController: UIPresentationController {

  private var direction: PresentationDirection
  private var dimmingView: UIView!


  init(presentedViewController: UIViewController, presentingViewController: UIViewController?,direction:PresentationDirection) {
    self.direction = direction
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      //presented is child presenting is parent
    setupDimmingView()
    
  }
  
  
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }
  
  
  override func presentationTransitionWillBegin() {
    guard let dimmingView = dimmingView else {
      return
    }
    // 1
    containerView?.insertSubview(dimmingView, at: 0)


    dimmingView.anchor(top: containerView?.topAnchor, left: containerView?.leftAnchor, bottom: containerView?.bottomAnchor, right: containerView?.rightAnchor)
    
    guard let coordinator = presentedViewController.transitionCoordinator else {return}
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 1.0
    })
    
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }

    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    })
  }
  
  
  override func containerViewWillLayoutSubviews() {
    //the view that will be animated
    presentedView?.frame = frameOfPresentedViewInContainerView //sidevc frame
  }
  
  
  //the size of the presented view controller’s content to the presentation controller
  override func size(forChildContentContainer container: UIContentContainer,
                     withParentContainerSize parentSize: CGSize) -> CGSize {
    switch direction {
    case .left, .right:
      return CGSize(width: parentSize.width*(1.8/3.0), height: parentSize.height)
    case .bottom, .top:
      return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
    }
  }
  
  //DETERMINIG THE STARTING POSITION and size of the presented view
  override var frameOfPresentedViewInContainerView: CGRect {
    //1
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: containerView!.bounds.size)

    //2
    switch direction {
    case .right:
      frame.origin.x = containerView!.frame.width*(1.2/3.0)
    case .bottom:
        frame.origin.y = containerView!.frame.height*(1/3.0)
    default:
      frame.origin = .zero
    }
    return frame
  }
  
  
  
  
  
}

private extension SlideInPresentationController {
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    let recognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(handleTap(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
}

