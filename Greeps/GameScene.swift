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
    var gvc: GameViewController?
    var ship: Ship?
    var water = SKNode()
    var obstacles = Dictionary<SKNode,GKPolygonObstacle>()
    var count = 0
    var scoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    var totalScoreLabel = SKLabelNode()
    let totalScoreLabelName = "totalScoreLabel"
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var lastGreepAddTime: TimeInterval = 0
    let greepDelayInterval: TimeInterval = 0.5
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        ship!.scene = self
        for w in water.children
        {
            let ob = SKNode.obstacles(fromNodeBounds: [w])
            obstacles[w] = ob.first!
        }
        
        for (_,obst) in obstacles
        {
            let path = UIBezierPath()
            let initialPoint = obst.vertex(at: 0)
            path.move(to: CGPoint(x: CGFloat(initialPoint.x), y: CGFloat(initialPoint.y)))
            for i in 0..<obst.vertexCount
            {
                let v = obst.vertex(at: i)
                path.addLine(to: CGPoint(x: CGFloat(v.x), y: CGFloat(v.y)))
            }
            path.close()
            let shape = SKShapeNode(path: path.cgPath)
            shape.strokeColor = UIColor.red
            addChild(shape)
        }
        

        self.scaleMode = .aspectFit
        let thinSize = self.frame.height * 0.01
        let halfThinSize = thinSize/2
        let topApron = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: thinSize), center:CGPoint(x: self.frame.width/2, y: self.frame.height - halfThinSize))
        let bottomApron = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: thinSize), center:CGPoint(x: self.frame.width/2, y: halfThinSize))
        
        let leftApron = SKPhysicsBody(rectangleOf: CGSize(width: thinSize, height: self.frame.height), center: CGPoint(x:halfThinSize, y:self.frame.height/2))
        let rightApron = SKPhysicsBody(rectangleOf: CGSize(width: thinSize, height: self.frame.height), center: CGPoint(x:self.frame.width - halfThinSize, y:self.frame.height/2))
        
        let apron = SKPhysicsBody(bodies: [topApron, bottomApron,leftApron,rightApron])
//        let framePhysicsLoop = SKPhysicsBody(edgeLoopFrom: self.frame)
        apron.categoryBitMask = PhysicsCategory.boundary.rawValue
        apron.isDynamic = false
        apron.isResting = true
        apron.affectedByGravity = false
        self.physicsBody = apron
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if ship!.shouldSpawnGreep && currentTime - lastGreepAddTime > greepDelayInterval
        {
            let greep = ship!.spawnGreep()
            entities.append(greep)
            addChild(greep.sprite)
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
        scoreLabel.text = "Level Score: " + "\(count)"
        totalScoreLabel.text = "Total Score: " + "\(String(describing: gvc!.totalScoreCounter))"
        self.lastUpdateTime = currentTime
    }
    func addScore()
    {
        scoreLabel = SKLabelNode(fontNamed: "Papyrus")
        scoreLabel.name = scoreLabelName
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "Level Score: " + " \(count)"
        scoreLabel.position = CGPoint(x:frame.size.width / 8, y:frame.size.height - frame.size.height / 14)
        self.addChild(scoreLabel)
        totalScoreLabel = SKLabelNode(fontNamed: "Papyrus")
        totalScoreLabel.name = totalScoreLabelName
        totalScoreLabel.fontSize = 40
        totalScoreLabel.fontColor = SKColor.white
        totalScoreLabel.text = "Total Score: " + "\(String(describing: gvc!.totalScoreCounter))"
        totalScoreLabel.position = CGPoint(x:frame.size.width / 8, y:frame.size.height - frame.size.height / 7)
        self.addChild(totalScoreLabel)
    }
    
    func addShip( at location: CGPoint, withGreepCount numberOfGreeps:Int )
    {
        let newShip = Ship(withScene:self)
        newShip.setPosition(position: location)
        newShip.greepsToSpawn = numberOfGreeps
        entities.append(newShip)
        addChild(newShip.sprite!)
        self.ship = newShip
    }
    
    func addWater( ofType fileName: String, at location: CGPoint, scaledBy scale:Float, rotatedBy rotation: Float)
    {
        if water.parent == nil
        {
            addChild(water)
        }
        let texture = SKTexture(imageNamed: "\(fileName).png")
        let sprite = SKSpriteNode(texture: texture)
        sprite.setScale(CGFloat(scale))
        sprite.zRotation = CGFloat(rotation)
        sprite.position = location
        let physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.3, size: sprite.size)
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsCategory.water.rawValue
        sprite.physicsBody = physicsBody
        water.addChild(sprite)
    }
    
    func addTomatoPile(at location: CGPoint)
    {
        let pile = TomatoPile(location: location)
        addChild(pile.sprite!)
        entities.append(pile)
    }
    
    func addTomatoPile(at location: CGPoint, ofSize count:UInt8 )
    {
        let pile = TomatoPile(location: location, count: count)
        addChild(pile.sprite!)
        entities.append(pile)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.greep.rawValue
        {
            let greep = contact.bodyA.node!.entity as! Greep

            switch contact.bodyB.categoryBitMask
            {
                case PhysicsCategory.boundary.rawValue:
                    if greep.state != .AvoidingObstacle
                    {
                        greep.state = .AtEdge
                        greep.speed = 0
                        greep.behavior = WaitGreepBehavior()
                        greep.contactedEdge()
                    }
                case PhysicsCategory.water.rawValue:
                    greep.speed = 0
                    greep.state = .AtWater
                    for w in water.children
                    {
                        if w.contains(contact.contactPoint)
                        {
                            greep.contactedWater(obstacles[w]!)
                            return
                        }
                    }
                case PhysicsCategory.ship.rawValue:
                    greep.unloadTomatoPile()
                    greep.contactedShip()
                case PhysicsCategory.tomato.rawValue:
                    let tomatoPile = contact.bodyB.node!.entity as! TomatoPile
                    greep.contactedTomato(tomatoPile)
                    break
                case PhysicsCategory.greep.rawValue:
                    let otherGreep = contact.bodyB.node!.entity as! Greep
                    greep.contactedGreep( otherGreep )
                default:
                    return
            }
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.greep.rawValue
        {
            let greep = contact.bodyB.node!.entity as! Greep
            switch contact.bodyA.categoryBitMask
            {
                case PhysicsCategory.boundary.rawValue:
                    if greep.state != .AvoidingObstacle
                    {
                        greep.state = .AtEdge
                        greep.speed = 0
                        greep.behavior = WaitGreepBehavior()
                        greep.contactedEdge()
                    }
                case PhysicsCategory.water.rawValue:
                    greep.speed = 0
                    greep.state = .AtWater
                    for w in water.children
                    {
                        if w.contains(contact.contactPoint)
                        {
                            greep.contactedWater(obstacles[w]!)
                            return
                        }
                    }
                case PhysicsCategory.ship.rawValue:
                    greep.unloadTomatoPile()
                    greep.contactedShip()
                case PhysicsCategory.tomato.rawValue:
                    let tomatoPile = contact.bodyA.node!.entity as! TomatoPile
                    greep.contactedTomato(tomatoPile)
                    break
                case PhysicsCategory.greep.rawValue:
                    let otherGreep = contact.bodyA.node!.entity as! Greep
                    greep.contactedGreep( otherGreep )
                default:
                    return
            }
        }
    }
}
