//
//  Ball.swift
//  jumpingGame
//
//  Created by djepbarov on 9.01.2019.
//  Copyright © 2019 Davut. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    convenience init(color: UIColor, size: CGSize = CGSize(width: 50, height: 50)) {
        self.init(texture: nil, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Ball {
    static func ==(lhs: Ball, rhs:Ball) -> Bool {
        if lhs.size.width == rhs.size.height {
            return true
        }
        return false
    }
    
    static func >(lhs: Ball, rhs:Ball) -> Bool {
        if lhs.size.width > rhs.size.height {
            return true
        }
        return false
    }
    
    static func <(lhs: Ball, rhs:Ball) -> Bool {
        if lhs.size.width < rhs.size.height {
            return true
        }
        return false
    }
}
