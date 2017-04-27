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
    private var previousCount: UInt8
    var agent = GKAgent2D()
    var count: Count
    
    var sprite: SKNode?
    {
        guard let sprite = component(ofType: GKSKNodeComponent.self) else { return nil }
        return sprite.node
    }
    
    init( location: CGPoint, count qty: UInt8 )
    {
        tomatoCount = qty
        previousCount = qty
        self.count = Count.countForQuantity(qty)
        super.init()
        
        let spriteComponent = GKSKNodeComponent(node: SKSpriteNode(imageNamed: "tomatoPile-\(count)"))
        spriteComponent.node.entity = self
        
        spriteComponent.node.setScale(CGFloat(0.25))
        
        let sprite = spriteComponent.node as! SKSpriteNode
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
