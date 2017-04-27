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
    static let defaultSpeed:Float = 80.0
    static let wanderAmount:Float = 10.0
    var informationTimer: TimeInterval? = nil
    var timer: TimeInterval? = nil
    var state: State = .Searching
    var nextState: State?
    var nextBehavior: GKBehavior?
    var pendingMemory: Information? // not allowed to use this variable
    var memory = Memory()
    var number: UInt8 = 0// get rid.
    
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
    
    init( ship: Ship )
    {
        self.ship = ship
        super.init()
        
        let shipPosition = ship.getPosition()
        let spriteComponent = GKSKNodeComponent(node: SKSpriteNode(imageNamed: "greep_green.png"))
        spriteComponent.node.setScale(0.05)
        spriteComponent.node.entity = self
        
        let sprite = spriteComponent.node as! SKSpriteNode
        let physics = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        physics.categoryBitMask = PhysicsCategory.greep.rawValue
        physics.collisionBitMask = PhysicsCategory.water.rawValue | PhysicsCategory.boundary.rawValue
        physics.contactTestBitMask = ( (PhysicsCategory.tomato.rawValue | PhysicsCategory.water.rawValue) | (PhysicsCategory.ship.rawValue | PhysicsCategory.greep.rawValue) ) | PhysicsCategory.boundary.rawValue
        physics.affectedByGravity = false
        spriteComponent.node.physicsBody = physics
        spriteComponent.node.position = shipPosition

        addComponent(spriteComponent)
        
        let mover = MoveComponent(ship: ship)
        mover.delegate = spriteComponent
        mover.position = float2( x: Float(shipPosition.x), y: Float(shipPosition.y))
        spriteComponent.node.zRotation = CGFloat(mover.rotation)
        addComponent(mover)
        studentInitialization()
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
    
    func loadTomatoFromPile( _ pile: TomatoPile )
    {
        
    }
    
    func unloadTomatoPile( )
    {
        
    }
    
    func gatherInformationAbout( obstacle: GKObstacle, postState: State, postBehavior: GKBehavior )
    {
        if state != .GatheringInformation
        {
            state = .GatheringInformation
            updateBehaviorTo(GatheringInformationBehavior())
            speed = 0
            if informationTimer == nil
            {
                informationTimer = 5 // fixed for now, would like it based on area of obstacle
            }
            nextState = postState
            nextBehavior = postBehavior
            print( "next: \(nextBehavior)")
            pendingMemory = Information(info: obstacle)!
        }
        else
        {
            if informationTimer! <= 0
            {
                didFinishGatheringInformation()
            }
        }
    }
    
    func didFinishGatheringInformation()
    {
        changeToNextBehavior()
        informationTimer = nil
        speed = Greep.defaultSpeed
        memory.add(information: pendingMemory! )
    }
    
    func updateBehaviorTo( _ newBehaviour: GKBehavior )
    {
        guard let mover = component(ofType: MoveComponent.self) else { return }
        mover.behavior = newBehaviour
    }
    
    func changeToNextBehavior()
    {
        if nextState == nil
        {
            state = .Searching
            updateBehaviorTo(DefaultGreepBahaviour())
        }
        else
        {
            state = nextState!
            nextState = nil
            if nextBehavior == nil
            {
                nextBehavior = DefaultGreepBahaviour()
            }
            print( "Doing: \(nextBehavior!)")
            updateBehaviorTo(nextBehavior!)
            nextBehavior = nil
        }
    }
    
    func updateTimers(deltaTime seconds: TimeInterval)
    {
        if informationTimer != nil
        {
            if informationTimer! > 0
            {
                informationTimer! -= seconds
            }
            else
            {
                didFinishGatheringInformation()
            }
        }
        
        if timer != nil
        {
            if timer! > 0
            {
                timer! -= seconds
            }
            else
            {
                changeToNextBehavior()
                timer = nil
            }
        }
    }
}
