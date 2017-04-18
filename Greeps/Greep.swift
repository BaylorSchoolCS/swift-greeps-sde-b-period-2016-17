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
    var state:GKStateMachine?
    var memory = Set<Information>()
    var number: UInt8 = 0
    var timer: UInt8 = 0
    
    var speed: Float
    {
        guard let mover = component(ofType: MoveComponent.self) else { return 0 }
        return mover.speed
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
    
    init( ship: Ship )
    {
        self.ship = ship
        
        super.init()
        
        state = GKStateMachine(states: [SearchingState(greep: self), ReturningHomeState(greep: self), WaitState(greep: self), AtObstacleState(greep: self)])
        
        let shipPosition = ship.getPosition()
        let spriteComponent = GKSKNodeComponent(node: SKSpriteNode(imageNamed: "greep_green.png"))
        spriteComponent.node.setScale(0.05)
        let sprite = spriteComponent.node as! SKSpriteNode
        
        let physics = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        physics.categoryBitMask = PhysicsCategory.greep.rawValue
        physics.collisionBitMask = PhysicsCategory.water.rawValue
        physics.contactTestBitMask =  PhysicsCategory.tomato.rawValue | PhysicsCategory.ship.rawValue
        physics.affectedByGravity = false

        spriteComponent.node.physicsBody = physics
        spriteComponent.node.position = shipPosition
        
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
    
    func gatherInformationAbout( obstacle: GKObstacle )
    {
        
    }
    
    func shareInformation(otherMemory: Set<Information>)
    {
        
    }
}
