//
//  GameScene.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var ship: Ship = Ship()
    var greepsToSpawn = [Greep]()
    var water = SKNode()
    var tomatoPiles = [TomatoPile]()
    var obstacles = [GKPolygonObstacle]()
    
    let greepDelayInterval: TimeInterval = 0.5
    private var lastUpdateTime : TimeInterval = 0
    private var lastGreepAddTime: TimeInterval = 0
    
    var foundTomatoTimer: TimeInterval = 10
    var turnHomeTimer: TimeInterval = 90
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        obstacles = SKNode.obstacles(fromNodeBounds: water.children)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if greepsToSpawn.count > 0 && currentTime - lastGreepAddTime > greepDelayInterval
        {
            let greep = greepsToSpawn.removeFirst()
            entities.append(greep)
            addChild(greep.sprite!)
            lastGreepAddTime = currentTime
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        turnHomeTimer -= dt
        foundTomatoTimer -= dt
        // Update entities

        for entity in self.entities {
            if turnHomeTimer <= 0
            {
                if let greep = entity as? Greep
                {
                    greep.updateBehaviorTo(ReturnHomeGreepBehavior(ship: ship))
                }
            }
            
            if foundTomatoTimer <= 0
            {
                if let greep = entity as? Greep
                {
                    let pile = tomatoPiles.first!
                    greep.updateBehaviorTo(GoToPileAndAvoidBehavior(tomatoPile: pile.agent, obstacles: obstacles))
                }
            }
            
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func addShip( at location: CGPoint, withGreepCount numberOfGreeps:Int )
    {
        ship.setPosition(position: location)
        greepsToSpawn = ship.spawnGreeps(count: numberOfGreeps)
        entities.append(ship)
        addChild(ship.sprite!)
    }
    
    func addWater( ofType fileName: String, at location: CGPoint, scaledBy scale:Float, rotatedBy rotation: Float)
    {
        let sprite = SKSpriteNode(imageNamed: "\(fileName).png")
        water.addChild(sprite)
        sprite.setScale(CGFloat(scale))
        sprite.zRotation = CGFloat(rotation)
        sprite.position = location
        guard let texture = sprite.texture else { fatalError("no sprite") }
        let physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.3, size: sprite.size)
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsCategory.water.rawValue
        sprite.physicsBody = physicsBody
    }
    
    func addTomatoPile(at location: CGPoint, ofSize count:UInt8 )
    {
        let pile = TomatoPile(location: location, count: count)
        tomatoPiles.append(pile)
        addChild(pile.node)
    }
}
