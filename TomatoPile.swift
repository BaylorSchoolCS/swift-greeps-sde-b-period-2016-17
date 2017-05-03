//
//  TomatoPile.swift
//  Greeps
//
//  Created by Jason Oswald on 2017-04-13.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class TomatoPile: GKEntity
{
    enum Count
    {
        case empty, single, few, many
        
        static func countForQuantity( _ num: UInt8 ) -> Count
        {
            switch num
            {
                case 0: return .empty
                case 1: return .single
                case 2...10: return .few
                default: return .many
            }
        }
    }
    
    
    private var tomatoCount: UInt8
        {
        didSet
        {
            count = Count.countForQuantity(tomatoCount)
        }
    }
    
    private var previousCount: UInt8
    var agent = GKAgent2D()
    var count: Count
        {
        didSet
        {
            if count != oldValue
            {
                let newSprite = currentSprite()
                sprite = newSprite
            }
        }
    }
    
    var sprite: SKNode?
        {
        get {
            guard let sprite = component(ofType: GKSKNodeComponent.self) else { return nil }
            return sprite.node
        }
        set( newSprite )
        {
            guard let sprite = component(ofType: GKSKNodeComponent.self) else { fatalError("sprite not set yet") }
            let physics = sprite.node.physicsBody
            let scene = sprite.node.parent!
            sprite.node.removeFromParent()
            sprite.node = newSprite!
            sprite.node.physicsBody = physics
            sprite.node.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y) )
            scene.addChild(newSprite!)
        }
    }
    
    convenience init( location: CGPoint )
    {
        self.init( location: location, count: UInt8( 1 + arc4random() % 40 ) )
    }
    
    init( location: CGPoint, count qty: UInt8 )
    {
        tomatoCount = qty
        previousCount = qty
        self.count = Count.countForQuantity(tomatoCount)
        super.init()
        
        let sprite = currentSprite()
        let spriteComponent = GKSKNodeComponent(node: sprite)
        spriteComponent.node.entity = self
        spriteComponent.node.setScale(CGFloat(0.25))
        spriteComponent.node.position = location
        
        let physics = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        physics.categoryBitMask = PhysicsCategory.tomato.rawValue
        physics.isDynamic = false
        physics.isResting = true
        physics.affectedByGravity = false
        spriteComponent.node.physicsBody = physics
        
        
        addComponent(spriteComponent)
        
        agent.position = float2(x:Float(location.x), y: Float(location.y))
        
        addComponent(agent)
    }
    
    func currentSprite() -> SKSpriteNode
    {
        let newSprite = SKSpriteNode(imageNamed: "tomatoPile-\(count)")
        newSprite.entity = self
        newSprite.setScale(CGFloat(0.25))
        return newSprite
    }
    
    func removeTomato()
    {
        print( "removing tomato #\(tomatoCount) @\(DispatchTime.now())")
        if tomatoCount > 0
        {
            tomatoCount -= 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
