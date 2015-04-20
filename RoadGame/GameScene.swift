//
//  GameScene.swift
//  RoadGame
//
//  Created by uics7 on 4/8/15.
//  Copyright (c) 2015 uics7. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode! = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimeInterval:NSTimeInterval = NSTimeInterval()
    
    var aliens:NSMutableArray = NSMutableArray()
    var aliensDestroyed:Int = 0
    var gameover = false
    
    //let alienCategory:UInt32 = 0x1 << 1
    //let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    enum ColliderType : UInt32 {
        case car = 1
        case enemy = 2
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        gameover = true
        println("collided")
        var gameOverScene:SKScene = GameOverScene(size: self.size, won: false)

        
    }
    

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        player = SKSpriteNode(imageNamed: "car.png")
        player.position = CGPointMake(self.frame.size.width/2, player.size.height/2 + 20)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = ColliderType.car.rawValue
        player.physicsBody!.contactTestBitMask = ColliderType.enemy.rawValue
        player.physicsBody!.categoryBitMask = ColliderType.enemy.rawValue
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        

    }
    
    func addEnemy(){
        
        // Create enemy sprite
        var enemy:SKSpriteNode = SKSpriteNode(imageNamed: "ememy.png")
        enemy.frame
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody!.categoryBitMask = ColliderType.enemy.rawValue
        enemy.physicsBody?.contactTestBitMask = ColliderType.car.rawValue
        enemy.physicsBody?.collisionBitMask = 0

        // Where to create enemies along the x-axis
        let minX = enemy.size.width/2
        let maxX = self.frame.size.width - enemy.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(Int(arc4random_uniform(UInt32(UInt(rangeX ))))) + minX
        
        // Bring Enemies of screen
        enemy.position = CGPointMake(position, self.frame.size.height+enemy.size.height)
        
        self.addChild(enemy)
        aliens.addObject(enemy)
        
        // enemy Animation Duration
        
        let minDuration = 2
        let maxDurcation = 4
        let rangeDuration = maxDurcation - minDuration
        let duration = (Int(arc4random()) % Int(rangeDuration)) + Int(minDuration)
        
        
        // Create actions to animate
        
          var actionArray:NSMutableArray = NSMutableArray()
        
        actionArray.addObject(SKAction.moveTo(CGPointMake(position, -enemy.size.height), duration: NSTimeInterval(duration)))
            actionArray.addObject((SKAction.runBlock({
            var transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
//            var gameOverScene:SKScene = GameOverScene(size: self.size, won: false)
//           self.view?.presentScene(gameOverScene, transition: transition)
        })))
//        
      actionArray.addObject(SKAction.removeFromParent())
        enemy.runAction(SKAction.sequence(actionArray))
        
        }

    
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1){
            lastYieldTimeInterval = 0
            self.addEnemy()
        }
        
        
            
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        // < 60fps, we still want everything to move the ssame distance
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if (timeSinceLastUpdate > 1){// More than a second since last update
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        self.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var touch : UITouch
        for touch in touches {
            let location :CGPoint = touch.locationInNode(self)
            let newPosition : CGPoint = CGPointMake(location.x, 100)
            self.player.position = newPosition
            
        }
        
              }
    }
   

