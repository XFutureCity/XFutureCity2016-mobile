//
//  ScaleAnimator.swift
//  PocAnimationZoomIn
//
//  Created by Caylus Michael on 4/2/16.
//  Copyright © 2016 Caylus Michael. All rights reserved.
//

import UIKit

class ScaleAnimator : NSObject, UIViewControllerAnimatedTransitioning {

    let duration   = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->())?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.layer.cornerRadius = 10
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        let detailView = presenting ? toView : fromView
        let initialFrame = presenting ? self.originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : self.originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if self.presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)
        
        UIView.animateWithDuration(duration, delay:0.0,
                                   options: [],
                                   animations: {
                                    detailView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform
                                    detailView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
                                    
            }, completion:{_ in
                
                if !self.presenting {
                    self.dismissCompletion?()
                }
                transitionContext.completeTransition(true)
        })
    }
}