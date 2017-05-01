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
    static let gatherInformationTime: DispatchTimeInterval = .milliseconds(5000)
    static let shareInformationTime: DispatchTimeInterval = .milliseconds(1000)
    
    var state: State = .Searching
    var memory = Memory()
    var number: UInt8 = 0
    
    var isCarryingTomato = false
    
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
    
    var sprite: SKNode
    {
        get {
            guard let sprite = component(ofType: GKSKNodeComponent.self) else { fatalError("sprite component hasn't been created") }
            return sprite.node
        }
        set(newSprite)
        {
            guard let sprite = component(ofType: GKSKNodeComponent.self) else { fatalError("sprite component hasn't been created") }
            sprite.node = newSprite
        }
    }
    
    var mover: MoveComponent
    {
        guard let moverComponent = component(ofType: MoveComponent.self) else { fatalError("move component hasn't been created") }
        return moverComponent
    }
    
    var position: CGPoint
    {
        get
        {
            return CGPoint( x: CGFloat(mover.position.x), y: CGFloat(mover.position.y) )
        }
        
        set( newPosition )
        {
            mover.position = float2(x: Float(newPosition.x), y: Float(newPosition.y))
        }
    }
    
    var behavior: GKBehavior
    {
        get
        {
            return mover.behavior!
        }
        set( newBehavior )
        {
            mover.behavior = newBehavior
        }
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
        isCarryingTomato = false
        ship.addTomato()
        speed = 0
        state = .Waiting
        behavior = WaitGreepBehavior()
        let newSprite = SKSpriteNode(imageNamed: "greep_green.png")
        newSprite.setScale(0.05)
        sprite = newSprite
        postUnloadTomato()
    }
    
    func perform( behavior newBehavior: GKBehavior, forMilliseconds ms: Int, withState newState: Greep.State, postState: Greep.State, postBehavior: GKBehavior )
    {
        if state != newState
        {
            state = newState
            behavior = newBehavior
            GameViewController.delayQueue.asyncAfter(deadline: .now() + .milliseconds(ms)) {
                self.state = postState
                self.behavior = postBehavior
            }
        }
    }
    
    func storeTomatoLocationAbout( _ pile: TomatoPile, overwriteObstacle: Bool, overwriteOtherTomatoPile: Bool )
    {
        guard let info = Information(info: pile) else { fatalError("invalid information") }
        if memory.hasEmptySlot()
        {
            memory.add( information: info )
        }
        else if overwriteObstacle || overwriteOtherTomatoPile
        {
            for i in 0...2
            {
                if let infoInSlot = memory.infoInSlot(i)
                {
                    if (infoInSlot.isObstacle && overwriteObstacle) || (infoInSlot.isTomato && overwriteOtherTomatoPile)
                    {
                        memory.add(information: info, toSlot: i)
                        return
                    }
                }
            }
        }
        
    }
    
    func gatherInformationAbout( obstacle: GKObstacle, postState: State, postBehavior: GKBehavior )
    {
        if state != .GatheringInformation
        {
            state = .GatheringInformation
            behavior = GatheringInformationBehavior()
            speed = 0
            if let pendingInfo = Information(info: obstacle)
            {
                GameViewController.delayQueue.asyncAfter(deadline: .now() + Greep.gatherInformationTime) {
                    self.state = postState
                    self.behavior = postBehavior
                    self.memory.add(information: pendingInfo )
                    self.speed = Greep.defaultSpeed
                }
            }
        }
    }
    
    func willShareInformation() -> (State, GKBehavior)
    {
        if state != .SharingInformation
        {
            let previousState = state
            let previousBehavior = behavior
            state = .SharingInformation
            behavior = GatheringInformationBehavior()
            speed = 0
            return (previousState, previousBehavior)
        }
        else
        {
            return (state,behavior)
        }
    }
    
    func shareInformationWith( _ otherGreep: Greep, postState: State? = nil, postBehavior: GKBehavior? = nil)
    {
        let (previousState, previousBehavior) = willShareInformation()
        let (otherGreepPreviousState, otherGreepPreviousBehavior) = otherGreep.willShareInformation()
        GameViewController.delayQueue.asyncAfter(deadline: .now() + Greep.shareInformationTime) {
            self.state = postState == nil ? previousState : postState!
            self.behavior = postBehavior == nil ? previousBehavior : postBehavior!
            self.exchangeInformationWith( otherGreep )
            self.speed = (self.state == .AtWater || self.state == .AtEdge ) ? 0 : Greep.defaultSpeed  
            otherGreep.state = otherGreepPreviousState
            otherGreep.speed = (otherGreep.state == .AtWater || otherGreep.state == .AtEdge ) ? 0 : Greep.defaultSpeed
            otherGreep.behavior = otherGreepPreviousBehavior
            otherGreep.postSharedWith()
        }
        
    }
}
