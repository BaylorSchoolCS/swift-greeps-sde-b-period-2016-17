//
//  GameScene.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var ship: Ship = Ship()
    var greeps = Dictionary<String,Greep>()
    var water = SKNode()
    var tomatoPiles = [TomatoPile]()
    var obstacles = Dictionary<SKNode,GKPolygonObstacle>()
    var count = 0
    var obs = Dictionary<SKNode,GKPolygonObstacle>()
    var scoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var lastGreepAddTime: TimeInterval = 0
    let greepDelayInterval: TimeInterval = 0.5
    
    var foundTomatoTimer: TimeInterval = 10
    var turnHomeTimer: TimeInterval = 90
    

    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        for w in water.children
        {
            let ob = SKNode.obstacles(fromNodeBounds: [w])
            obstacles[w] = ob.first!
        }
        

        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.boundary.rawValue
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if ship.shouldSpawnGreep && currentTime - lastGreepAddTime > greepDelayInterval
        {
            let greep = ship.spawnGreep()
            greeps[greep.name] = greep
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

        for entity in self.entities {

            
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    func addScore()
    {
        scoreLabel = SKLabelNode(fontNamed: "ScoreLabel")
        scoreLabel.name = scoreLabelName
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "\(count)"
        print(size.height )
        scoreLabel.position = CGPoint(x:frame.size.width / 20, y:frame.size.height - frame.size.height / 14)
        self.addChild(scoreLabel)
    }
    
    func addShip( at location: CGPoint, withGreepCount numberOfGreeps:Int )
    {
        ship.setPosition(position: location)
        ship.greepsToSpawn = numberOfGreeps
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.greep.rawValue
        {
            let greep = greeps[contact.bodyA.node!.name!]!
            switch contact.bodyB.categoryBitMask
            {
                case PhysicsCategory.boundary.rawValue:
                    greep.contactedEdge()
                case PhysicsCategory.water.rawValue:
                    for w in water.children
                    {
                        if w.contains(contact.contactPoint)
                        {
                            greep.contactedWater(obstacles[w]!)
                        }
                    }
                case PhysicsCategory.ship.rawValue:
                    greep.contactedShip()
                case PhysicsCategory.tomato.rawValue:
                    greep.contactedTomato()
                default:
                    return
            }
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.greep.rawValue
        {
            let greep = greeps[contact.bodyB.node!.name!]!
            switch contact.bodyA.categoryBitMask
            {
                case PhysicsCategory.boundary.rawValue:
                    greep.contactedEdge()
                case PhysicsCategory.water.rawValue:
                    for w in water.children
                    {
                        if w.contains(contact.contactPoint)
                        {
                            greep.contactedWater(obstacles[w]!)
                        }
                    }
                case PhysicsCategory.ship.rawValue:
                    greep.contactedShip()
                case PhysicsCategory.tomato.rawValue:
                    greep.contactedTomato()
                default:
                    return
            }
        }
    }
}
