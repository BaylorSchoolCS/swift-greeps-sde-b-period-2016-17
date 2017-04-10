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
    static let defaultSpeed:Float = 2100.0
    static let wanderAmount:Float = 50.0
    var memory = Set<Information>()
    var number: UInt8 = 0
    var timer: UInt8 = 0
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
        let spriteComponent = GKSKNodeComponent(node: SKSpriteNode(imageNamed: "greep.png"))
        spriteComponent.node.setScale(0.1)
        spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategories.greepCategory.rawValue
        spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategories.waterCategory.rawValue | PhysicsCategories.tomatoCategory.rawValue | PhysicsCategories.shipCategory.rawValue
        addComponent(spriteComponent)
        
        let shipPosition = ship.getPosition()
        
        let mover = MoveComponent(ship: ship)
        mover.delegate = spriteComponent
        mover.position = float2( x: Float(shipPosition.x), y: Float(shipPosition.y))
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
