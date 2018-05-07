//
//  SlideTransition.swift
//  Hang
//
//  Created by Joe Kennedy on 5/3/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import UIKit

class ScaleTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration  = 0.5
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        
//        let screenOffRight = CGAffineTransform(translationX: -container.frame.width, y: 0)
//        let screenOffLeft = CGAffineTransform(translationX: container.frame.width, y: 0)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.alpha = 0
        toView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            fromView.transform = CGAffineTransform(scaleX: 2, y: 2)
            fromView.alpha = 0
            //toView.transform = CGAffineTransform(scaleX: 1, y: 1)
            toView.alpha = 1

        }) { (success) in
            transitionContext.completeTransition(success)
        }

    }
    
    

}
