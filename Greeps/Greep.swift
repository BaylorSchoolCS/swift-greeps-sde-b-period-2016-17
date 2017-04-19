//
//  Greep.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class Greep: GKEntity
{
    let ship: Ship
    static let defaultSpeed:Float = 40.0
    static let wanderAmount:Float = 10.0
    var informationTimer: TimeInterval = 0
    var state: State {
        get
        {
            return self.state
        }
        set
        {
            if informationTimer <= 0
            {
                self.state = newValue
            }
        }
    }
    var memory1: Information?
    var memory2: Information?
    var memory3: Information?
    var number: UInt8 = 0
    var timer: UInt8 = 0
    
    var speed: Float
    {
        get {
            guard let mover = component(ofType: MoveComponent.self) else { return 0 }
            return mover.speed
        }
        set(newSpeed) {
            guard let mover = component(ofType: MoveComponent.self) else { return }
            mover.speed = newSpeed
        }
    }
    
    var sprite: SKNode?
    {
        guard let sprite = component(ofType: GKSKNodeComponent.self) else { return nil }
        return sprite.node
    }
    
    var position: CGPoint
    {
        get
        {
            guard let mover = component(ofType: MoveComponent.self) else { fatalError("move component has been created") }
            return CGPoint( x: CGFloat(mover.position.x), y: CGFloat(mover.position.y) )
        }
        
        set( newPosition )
        {
            guard let mover = component(ofType: MoveComponent.self) else { fatalError("move component has been created") }
            mover.position = float2(x: Float(newPosition.x), y: Float(newPosition.y))
        }
    }
    
    var name: String
    {
        guard let sprite = component(ofType: GKSKNodeComponent.self) else { return "no name" }
        
        return sprite.node.name!
    }
    
    init( ship: Ship, number: Int )
    {
        self.ship = ship
        
        super.init()
        self.state = .Searching
        let shipPosition = ship.getPosition()
        let spriteComponent = GKSKNodeComponent(node: SKSpriteNode(imageNamed: "greep_green.png"))
        spriteComponent.node.setScale(0.05)
        let sprite = spriteComponent.node as! SKSpriteNode
        
        let physics = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        physics.categoryBitMask = PhysicsCategory.greep.rawValue
        physics.collisionBitMask = PhysicsCategory.water.rawValue | PhysicsCategory.boundary.rawValue
        physics.contactTestBitMask =  (PhysicsCategory.tomato.rawValue | PhysicsCategory.water.rawValue) | (PhysicsCategory.ship.rawValue | PhysicsCategory.boundary.rawValue)
        physics.affectedByGravity = false

        spriteComponent.node.physicsBody = physics
        spriteComponent.node.position = shipPosition
        physics.node!.name = "greep\(number)"
        
        addComponent(spriteComponent)
        
        let mover = MoveComponent(ship: ship)
        mover.delegate = spriteComponent
        mover.position = float2( x: Float(shipPosition.x), y: Float(shipPosition.y))
        spriteComponent.node.zRotation = CGFloat(mover.rotation)
        addComponent(mover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRotation( newRotation: Float )
    {
        guard let mover = component(ofType: MoveComponent.self) else { return }
        mover.rotation = newRotation
    }
    
    func rotate( delta: Float )
    {
        guard let mover = component(ofType: MoveComponent.self) else { return }
        mover.rotation += delta
    }
    
    func gatherInformationAbout( obstacle: GKObstacle ) -> Information
    {
        speed = 0
        updateBehaviorTo(GatheringInformationBehavior())
        informationTimer = 5 // fixed for now, would like it based on area of obstacle
        state = .GatheringInformation
        return Information(info: obstacle)!
    }
    
    func shareInformation(otherMemory: Set<Information>)
    {
        
    }
    
    func updateBehaviorTo( _ newBehaviour: GKBehavior )
    {
        guard let mover = component(ofType: MoveComponent.self) else { return }
        mover.behavior = newBehaviour
    }
}
