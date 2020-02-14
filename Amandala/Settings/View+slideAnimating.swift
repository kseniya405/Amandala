//
//  UIView+slideAnimating.swift
//  Xeroe
//
//  Created by Денис Марков on 9/24/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public enum Animation {
        case down
        case up
        case none
    }
    
    func slideIn(from edge: Animation = .none, x: CGFloat = 0, y: CGFloat = 0, durations: TimeInterval = 1, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        
        let offset = offcetFor(edge: edge)
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        
        isHidden = false
        
        UIView.animate(withDuration: durations, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
            self.transform = .identity
            self.alpha = 1
            }, completion: completion)

    }
    
    func slideOut(from edge: Animation = .none, x: CGFloat = 0, y: CGFloat = 0, durations: TimeInterval = 1, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        
        let offset = offcetFor(edge: edge)
        let endtransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        
        UIView.animate(withDuration: durations, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.transform = endtransform
            self.alpha = 1
        }, completion: completion)
        
    }
    
    private func offcetFor(edge: Animation) -> CGPoint {
        if let size = self.superview?.frame.size {
            switch edge {
            case .none :
                return .zero
            case .down:
                return CGPoint(x: 0, y: -frame.maxY)
            case .up:
                return CGPoint(x: 0, y: size.height - frame.minY)
            }
        }
        return .zero
    }
}
