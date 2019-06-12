//
//  ExpandTransitionAnimation.swift
//  Counter
//
//  Created by Tudor Croitoru on 10/06/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit
import Foundation

class ExpandAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let sender: CounterCell
    private let originFrame: CGRect
    private let titleFrame: CGRect
    private let countFrame: CGRect
    private let title: String
    
    init(sender: CounterCell, originFrame: CGRect, titleFrame: CGRect, countFrame: CGRect, title: String) {
        self.sender = sender
        self.originFrame = originFrame
        self.titleFrame = titleFrame
        self.countFrame = countFrame
        self.title = title
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView    = transitionContext.view(forKey: .to),
              let toVC      = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let background = UIView(frame: originFrame)
        background.backgroundColor = sender.backgroundColor
        background.layer.shadowColor = UIColor.darkGray.cgColor
        background.layer.shadowOffset = .init(width: 0.0, height: 5.0)
        background.layer.shadowRadius = 50.0
        background.layer.shadowOpacity = 0.5
        containerView.addSubview(background)
        
        containerView.addSubview(toView)
        toView.alpha = 0
        
        let senderTitleLabel = sender.titleLabel
        let senderCountLabel = sender.valueLabel
        
        let toTitleLabel = (toVC as! CounterViewController).titleLabel
        let toCountLabel = (toVC as! CounterViewController).counterLabel
        
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = senderTitleLabel?.text //so the size of the label doesn't jump
        titleLabel.textColor = senderTitleLabel?.textColor
        titleLabel.font = toTitleLabel?.font
        titleLabel.sizeToFit()
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.frame.origin = titleFrame.origin
        
        let tmpTitleLabelRect = senderTitleLabel!.textRect(forBounds: senderTitleLabel!.bounds, limitedToNumberOfLines: 1)
        
        let countLabel = UILabel(frame: countFrame)
        countLabel.text = senderCountLabel?.text
        countLabel.textColor = senderCountLabel?.textColor
        countLabel.font = toCountLabel?.font
        countLabel.sizeToFit()
        countLabel.textAlignment = .left
        countLabel.frame.origin = countFrame.origin
        
        let tmpCountLabelRect = senderCountLabel!.textRect(forBounds: senderCountLabel!.bounds, limitedToNumberOfLines: 1)
        
        let titleScaleFactor = titleLabel.frame.width / tmpTitleLabelRect.width
        let countScaleFactor = countLabel.frame.width / tmpCountLabelRect.width
        
        containerView.addSubview(countLabel)
        containerView.addSubview(titleLabel) // adding it second because i want this to go above the counter label when animating
        
        countLabel.transform = CGAffineTransform(scaleX: 1/countScaleFactor, y: 1/countScaleFactor)
        countLabel.center.y = countFrame.midY
        countLabel.center.x = tmpCountLabelRect.width / 2 + countFrame.minX
        
        titleLabel.transform = CGAffineTransform(scaleX: 1/titleScaleFactor, y: 1/titleScaleFactor)
        titleLabel.center.y = titleFrame.midY
        titleLabel.center.x = tmpTitleLabelRect.width / 2 + titleFrame.minX
        
        _ = (toVC as! CounterViewController).counterLabel.snapshotView(afterScreenUpdates: true) //force screen update so we get the correct height for the counter label
        
        let duration = transitionDuration(using: transitionContext)

        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        background.frame = toView.frame.insetBy(dx: 0, dy: -30)
                                                        background.layer.cornerRadius = 30.0
                                                        titleLabel.transform = .identity
                                                        countLabel.transform = .identity
                                                        titleLabel.frame = toTitleLabel!.frame
                                                        countLabel.frame.origin = toCountLabel!.frame.origin
                                                        countLabel.frame.size = toCountLabel!.frame.size
                                                        countLabel.adjustsFontSizeToFitWidth = true
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.01,
                                                       animations: {
                                                        toView.alpha = 1
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.51,
                                                       relativeDuration: 0.49,
                                                       animations: {
                                                        background.alpha = 0
                                    })
        }) { (_) in
            background.removeFromSuperview()
            countLabel.removeFromSuperview()
            titleLabel.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    
}
