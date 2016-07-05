//
//  Character.swift
//  SushiNeko
//
//  Created by Kadiatou Diallo on 6/30/16.
//  Copyright © 2016 Kadiatou Diallo. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode{
    var side: Side = .Left{
        didSet{
            if side == .Left{
                xScale = 1
                position.x = 70
            }
            else {
                //An easy way to flip an asset horizontally is to invert the X-axis scale 
                xScale = -1
                position.x = 252
                
            }
            /* Load/Run the punch action */
            let punch = SKAction(named: "punch")!
            runAction(punch)
        }
    }
    
    //You are required to implement this for your subclass to work
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

}
