//
//  GameScene.swift
//  SushiNeko
//
//  Created by Kadiatou Diallo on 6/30/16.
//  Copyright (c) 2016 Kadiatou Diallo. All rights reserved.
//

import SpriteKit

/* Tracking enum for use with character and sushi Side */
enum Side{
    case Right, Left, None
}

/* Tracking enum for game state */
enum GameState {
    case Title, Ready, Playing, GameOver
}
class GameScene: SKScene {
    
    // Game objects
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var mat: SKSpriteNode!
    var intro_Top: SKLabelNode!
    var intro_Bottom: SKLabelNode!

    /* Game management */
    var state: GameState = .Title
    var playButton: MSButtonNode!
    var scoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    var highscoreText: SKLabelNode!
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet{
            healthBar.xScale = health
        }
    }
    var score: Int = 0{
        didSet{
            scoreLabel.text = String(score)
        }
    }
    var highscoreVal: Int = 0{
        didSet{
        highscoreLabel.text = String(highscoreVal)
        }
    }
    override func didMoveToView(view: SKView) {
        
    
        //Connect Mat
        mat = childNodeWithName("Mat") as! SKSpriteNode
        
        //Connect Introduction
        intro_Top = childNodeWithName("intro_1") as! SKLabelNode
        intro_Bottom = childNodeWithName("intro_2") as! SKLabelNode
        highscoreLabel = childNodeWithName("highscoreLabel") as! SKLabelNode
        highscoreText = childNodeWithName("highscoreText") as! SKLabelNode
        //Connect Play Button
        playButton = childNodeWithName("playButton") as!MSButtonNode
       
        //Connect game object
        sushiBasePiece = childNodeWithName("sushiBasePiece")
            as! SushiPiece
    
      //Setup chopstick connection
       sushiBasePiece.connectChopstick()
        
        //Connect game object
        character = childNodeWithName("character")
            as! Character
        
        //Add sushi piece to the sushi tower
        sushiTower.append(sushiBasePiece)
        
        /* Randomize tower to just outside of the screen */
        addRandomPieces(50)
    
        //Setup play button selection handler
        
        playButton.selectedHandler = {
            
            //Start Game
            self.state = .Ready
        }
        
        
        //Connect Health Bar
        healthBar = childNodeWithName("healthBar") as!SKSpriteNode
        //Connect Score Label
        scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        
        scoreLabel.zPosition = 100
        
        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        
        if (highscoreDefault.valueForKey("Highscore") != nil){
            
        highscoreVal = highscoreDefault.valueForKey("Highscore") as! NSInteger
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        /* Game not ready to play */
        if state == .GameOver || state == .Title  {return}
       
        /* Game begins on first touch */
        if state == .Ready {
            
            highscoreLabel.hidden = true
            highscoreText.hidden = true
            mat.hidden = true
            intro_Top.hidden = true
            intro_Bottom.hidden = true
            playButton.hidden = true
            state = .Playing
           
            
        }
        for touch in touches {
            /* Get touch position in scene */
            let location = touch.locationInNode(self)

            /* Was touch on left/right hand side of screen? */
            if location.x > size.width / 2 {
                character.side = .Right
            } else {
                character.side = .Left
            }
            //Grab sushi piece on top of the base
            let firstPiece = sushiTower.first as SushiPiece!
            
            /* Increment Health */
            health += 0.01
            
            /* Increment Score */
            score += 1
            
            
            /* Cap Health */
            if health > 1.0 { health = 1.0}
            
            //Remove from sushi tower array
            sushiTower.removeFirst()
            
            //Remove from scene
            firstPiece.flip(character.side)
            
            if sushiTower.count == 8 {
                //Add a new sushi
                addRandomPieces(5)
            }
            
            /* Drop all the sushi pieces down one place */
            for node:SushiPiece in sushiTower {
                node.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -50), duration: 0.10))
                
                /* Reduce zPosition to stop zPosition climbing over UI */
                node.zPosition -= 1
            }
            
            /* Check character side against sushi piece side (this is the death collision check)*/
            if character.side == firstPiece.side {
                
                /* Drop all the sushi pieces down a place (visually) */
                for node:SushiPiece in sushiTower {
                    node.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -55), duration: 0.10))
                }
                
                gameOver()
                
                /* No need to continue as player dead */
                return
            }

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if state != .Playing { return }
        
        /* Decrease Health */
        health -= 0.01
        
        /* Has the player run out of health? */
        if health < 0 { gameOver() }
        
        if score > highscoreVal{
            highscoreVal = score
            
            var highscoreDefault = NSUserDefaults.standardUserDefaults()
            highscoreDefault.setValue(highscoreVal, forKey: "Highscore")
            highscoreDefault.synchronize()
        }

    }
    
    func addTowerPiece(side: Side){
        //add a new piece to the sushi tower
        
        //Copy original sushi piece
        let newPiece = sushiBasePiece.copy()  as! SushiPiece
        newPiece.connectChopstick()
        
        // Access last piece properties
        let lastPiece = sushiTower.last
        
        //Add on top of last piece, default on first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position = lastPosition + CGPoint(x: 0, y: 55)

        /* Increment Z to ensure it's on top of the last piece, default on first piece*/
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        //Set side
        newPiece.side = side
        
        //Add sushi to scene
        addChild(newPiece)
        
        //Add sushi piece to the sushi tower
        sushiTower.append(newPiece)
        
    }
    func addRandomPieces(total: Int){
        //Add Random sushi pieces to the sushi tower
        
        for _ in 1...total{
            //Need to access last piece properties
            let lastPiece = sushiTower.last as SushiPiece!
            
            //Need to ensure we don't create impossible sushi structures
            if lastPiece.side != .None {
                addTowerPiece(.None)
            } else {
                let rand = CGFloat.random(min: 0 , max: 1.0)
                
                if rand < 0.45 {
                    /* 45% Chance of a left piece */
                    addTowerPiece(.Left)
                } else if rand < 0.9 {
                    /* 45% Chance of a right piece */
                    addTowerPiece(.Right)
                } else {
                    /* 10% Chance of an empty piece */
                    addTowerPiece(.None)
                }
            }
        }
    
    
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        
        /* Turn all the sushi pieces red*/
        for node:SushiPiece in sushiTower {
            node.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50))
        }
        
        /* Make the player turn red */
        character.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50))
        
        /* Change play button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to the SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart GameScene */
            skView.presentScene(scene)
        }
        
        character.side = .Left
        scoreLabel.zPosition = 109
        highscoreLabel.hidden = false
        highscoreText.hidden = false
        mat.hidden = false
        playButton.hidden = false
        
        
    }
}
