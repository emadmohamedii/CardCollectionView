//
//  CardToDetailViewAnimator.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

protocol CardToDetailViewAnimating {
    /// The view (card) that will be used in the animation.
    func viewForTransition() -> UIView
    /// The initial frame of the transitioning view, relative to it's view controller.
    func beginFrameForTransition() -> CGRect
}

class CardToDetailViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        guard fromViewController is CardCollectionViewController else { fatalError("\(String(self))) should only be used to transition from card view") }
        let cardController = fromViewController as! CardCollectionViewController
        let cardViewSnapshot = cardController.viewForTransition().snapshotViewAfterScreenUpdates(false)
        let cardFrame = cardController.beginFrameForTransition()
        cardViewSnapshot.frame = cardFrame
        // add required view to context
        transitionContext.containerView()?.addSubview(toViewController.view)
        transitionContext.containerView()?.addSubview(cardViewSnapshot)
        toViewController.view.alpha = 0
        // animate
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 12,
            options: [],
            animations: {
                cardViewSnapshot.frame = toViewController.view.bounds
            }, completion: { _ in
                // finish animation and transition
                toViewController.view.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())

        })
    }
}
