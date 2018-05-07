//
//  PresentMapFromFriends.swift
//  Hang
//
//  Created by Joe Kennedy on 5/4/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import UIKit

class PresentMapFromFriends: NSObject, UIViewControllerAnimatedTransitioning {
    
    var cellFrame : CGRect!
    var cellTransform : CATransform3D!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let destination = transitionContext.viewController(forKey: .to) as! MapViewController
        let containerView = transitionContext.containerView
        
        containerView.addSubview(destination.view)
        
        //initial state
        
        let animator = UIViewPropertyAnimator(duration: 5, dampingRatio: 0.7) {
            
            //final state
        }
        
        animator.addCompletion {
            (finished) in
            
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
    }
    
    
    

}
