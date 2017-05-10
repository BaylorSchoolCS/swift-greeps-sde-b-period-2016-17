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
    
    private var tomatoCount: UInt8
    {
        didSet
        {
            count = Count.countForQuantity(tomatoCount)
        }
    }
    
    var sprite: SKNode?
    {
        get {
            guard let spriteComponent = component(ofType: GKSKNodeComponent.self) else { return nil }
            return spriteComponent.node
        }
        set( newSprite )
        {
            guard let spriteComponent = component(ofType: GKSKNodeComponent.self) else { fatalError("sprite not set yet") }
            let physics = spriteComponent.node.physicsBody
            newSprite!.physicsBody = physics
            newSprite!.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y) )

            let scene = spriteComponent.node.parent!
            spriteComponent.node.removeFromParent()
            
            spriteComponent.node = newSprite!
            scene.addChild(newSprite!)
        }
    }
    
    var agent = GKAgent2D()
    
    convenience init( location: CGPoint )
    {
        self.init( location: location, count: UInt8( 4 + arc4random() % 36 ) )
    }
    
    init( location: CGPoint, count qty: UInt8 )
    {
        tomatoCount = qty
        self.count = Count.countForQuantity(tomatoCount)
        super.init()
        
        let sprite = currentSprite()
        let spriteComponent = GKSKNodeComponent(node: sprite)
        
        let physics = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        physics.categoryBitMask = PhysicsCategory.tomato.rawValue
        physics.isDynamic = false
        physics.isResting = true
        physics.affectedByGravity = false
        
        spriteComponent.node.physicsBody = physics
        spriteComponent.node.position = location
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
    
    func removeTomato() -> Bool
    {
        if tomatoCount > 0
        {
            tomatoCount -= 1
            return true
        }
        else
        {
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
