//
//  DragFromTopController.swift
//  Counter
//
//  Created by Tudor Croitoru on 12/06/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit
import Foundation

class DragFromTopController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handle(_:)))
//        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handle(_:)))
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handle(_:)))
        gesture.edges = .top
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handle(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
//        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let translation = gestureRecognizer.location(in: gestureRecognizer.view!.superview!)
        var progress = abs(translation.y / 300)
        print(translation.y)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            if progress > 0.6 {
                finish()
            } else {
                cancel()
            }
            
        case .ended:
            interactionInProgress = false
            if progress > 0.6 {
                finish()
            } else {
                cancel()
            }
            
        default:
            break
        }
        
    }
}
