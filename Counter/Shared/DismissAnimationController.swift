//
//  DismissAnimationController.swift
//  Counter
//
//  Created by Tudor Croitoru on 11/06/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit
import Foundation

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC    = transitionContext.viewController(forKey: .from),
              let toView  = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let senderTitleLabel = (fromVC as! CounterViewController).titleLabel!
        let senderCountLabel = (fromVC as! CounterViewController).counterLabel!
        
        let toTitleLabel = sender.titleLabel!
        let toCountLabel = sender.valueLabel!
        
        containerView.addSubview(toView)
        
        let background = UIView(frame: fromVC.view.frame.insetBy(dx: 0, dy: -30))
        background.backgroundColor = fromVC.view.backgroundColor
        background.layer.shadowColor = UIColor.darkGray.cgColor
        background.layer.shadowOffset = .init(width: 0.0, height: 5.0)
        background.layer.shadowRadius = 50.0
        background.layer.shadowOpacity = 0.5
        background.layer.cornerRadius = 30.0
        containerView.addSubview(background)
        
        let titleLabel = UILabel(frame: senderTitleLabel.frame)
        titleLabel.text = toTitleLabel.text
        titleLabel.textColor = senderTitleLabel.textColor
        titleLabel.font = senderTitleLabel.font
        titleLabel.sizeToFit()
        titleLabel.frame.origin = senderTitleLabel.frame.origin
        titleLabel.text = title
        containerView.addSubview(titleLabel)
        
        let tmpTitleLabelRect = toTitleLabel.textRect(forBounds: toTitleLabel.bounds, limitedToNumberOfLines: 1)
        
        let countLabel = UILabel(frame: senderCountLabel.frame)
        countLabel.text = senderCountLabel.text
        countLabel.textColor = senderCountLabel.textColor
        countLabel.font = senderCountLabel.font
        countLabel.sizeToFit()
        countLabel.textAlignment = .left
        countLabel.frame.origin = senderCountLabel.frame.origin
        containerView.addSubview(countLabel)
        
        let tmpCountLabelRect = toCountLabel.textRect(forBounds: toCountLabel.bounds, limitedToNumberOfLines: 1)
        
        let titleScaleFactor = titleLabel.frame.width / tmpTitleLabelRect.width
        let countScaleFactor = countLabel.frame.width / tmpCountLabelRect.width
        
        let exitButton = (fromVC as! CounterViewController).backButton
        containerView.addSubview(exitButton!)
        
        let duration = transitionDuration(using: transitionContext)
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowAnimation.fromValue = 50.0
        shadowAnimation.toValue   = 0.0
        shadowAnimation.duration  = duration * 2/5
        shadowAnimation.isRemovedOnCompletion = false
        shadowAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let offsetAnim = CABasicAnimation(keyPath: "shadowOffset")
        offsetAnim.fromValue = CGSize(width: 0.0, height: 5.0)
        offsetAnim.toValue   = CGSize.zero
        offsetAnim.duration  = duration * 2/5
        offsetAnim.isRemovedOnCompletion = false
        offsetAnim.fillMode = CAMediaTimingFillMode.forwards
        
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.8,
                                                       animations: { [weak self] in
                                                        guard let self = self else { return }
                                                        background.frame = self.originFrame.insetBy(dx: 0, dy: 10)
                                                        exitButton?.center.y = self.originFrame.midY
                                                        background.layer.cornerRadius = 0.0
                                                        titleLabel.transform = CGAffineTransform(scaleX: 1/titleScaleFactor,
                                                                                                 y: 1/titleScaleFactor)
                                                        countLabel.transform = CGAffineTransform(scaleX: 1/countScaleFactor,
                                                                                                 y: 1/countScaleFactor)
                                                        
                                                        titleLabel.frame = self.titleFrame
                                                        countLabel.frame = self.countFrame
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.9,
                                                       animations: {
                                                        background.layer.add(shadowAnimation, forKey: "shadowRadius")
                                                        background.layer.add(offsetAnim, forKey: "shadowOffset")
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.8,
                                                       relativeDuration: 0.2,
                                                       animations: {
                                                        background.alpha = 0.0
                                                        exitButton?.alpha = 0.0
                                    })
        }) { (_) in
            
            toView.removeFromSuperview()
            background.removeFromSuperview()
            titleLabel.removeFromSuperview()
            countLabel.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
    }
    
}
