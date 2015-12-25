//
//  NavigationControllerDelegate.swift
//  AnimatedTabBar
//
//  Created by Franklin Schrans on 24/12/2015.
//  Copyright © 2015 Franklin Schrans. All rights reserved.
//

import UIKit

class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    @IBOutlet weak var tabBarController: UITabBarController!
    
    var lastSelectedIndex = 0
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MoveTransitionAnimator(tabBarController: self.tabBarController, lastIndex: tabBarController.selectedIndex)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
}

class MoveTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    var tabBarController: UITabBarController!
    var lastIndex = 0
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    init(tabBarController: UITabBarController, lastIndex: Int) {
        self.tabBarController = tabBarController
        self.lastIndex = lastIndex
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        containerView?.addSubview(toViewController!.view)
        
        var viewWidth = CGRectGetWidth(toViewController!.view.bounds)
        
        if tabBarController.selectedIndex < lastIndex {
            viewWidth = -viewWidth
        }
        
        toViewController!.view.transform = CGAffineTransformMakeTranslation(viewWidth, 0)
        
        UIView.animateWithDuration(self.transitionDuration((self.transitionContext)), delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 2.5, options: .TransitionNone, animations: {
            toViewController!.view.transform = CGAffineTransformIdentity
            fromViewController!.view.transform = CGAffineTransformMakeTranslation(-viewWidth, 0)
            }, completion: { _ in
                self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
                fromViewController!.view.transform = CGAffineTransformIdentity
        })
    }
}
