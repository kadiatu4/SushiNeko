//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Kadiatou Diallo on 6/30/16.
//  Copyright © 2016 Kadiatou Diallo. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
 // Chopstick Object
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    //You are required to implement this for your subclass to work
    override init(texture: SKTexture?, color: UIColor, size:CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    //You are required to implement this for your subclass to work
    
    required init? (coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func connectChopstick(){
    
        //Connect the child Chopstick
        
        rightChopstick = childNodeWithName("rightChopstick") as! SKSpriteNode
        leftChopstick = childNodeWithName("leftChopstick") as! SKSpriteNode
        
        //Set the default side 
        side = .None
    }
    
    //Sushi Type
    var side: Side = .None { //Gets Info from the Enum
        didSet {
            switch side {
            case .Left:
                //Show left Chopstick
                leftChopstick.hidden = false
            case .Right:
                //Show right Chopstick
                rightChopstick.hidden = false
            case .None:
                 //Hid all ChopStick
                leftChopstick.hidden = true
                rightChopstick.hidden = true
            }
        }
    
    
    
    }
    func flip(side: Side) {
        /* Flip the sushi out of the screen */
        
        var actionName: String = ""
        
        if side == .Left {
            actionName = "FlipRight"
        } else if side == .Right {
            actionName = "FlipLeft"
        }
        
        /* Load appropriate action */
        let flip = SKAction(named: actionName)!
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([flip,remove])
        runAction(sequence)
    }
}
