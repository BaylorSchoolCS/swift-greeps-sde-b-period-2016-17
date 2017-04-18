//
//  Ship.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class Ship: GKEntity
{
    var greepsToSpawn: Int = 0
    var spawnedGreeps: Int = 0
    
    var shouldSpawnGreep: Bool
    {
        return greepsToSpawn > spawnedGreeps
    }
    
    var sprite: SKNode?
    {
        guard let sprite = component(ofType: SpriteComponent.self) else { return nil }
        return sprite.node
    }
    
    var agent: GKAgent2D
    {
        return component(ofType: GKAgent2D.self)!
    }
    
    override init()
    {
        super.init()
        let sprite = SpriteComponent(texture: SKTexture(imageNamed: "ship.png"))
        sprite.node.physicsBody?.categoryBitMask = PhysicsCategory.ship.rawValue
        addComponent(sprite)
        addComponent( GKAgent2D() )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition( position: CGPoint )
    {
        guard let sprite = component(ofType: SpriteComponent.self) else { return }
        sprite.node.position = position
        guard let agent2d = component(ofType: GKAgent2D.self) else { return }
        agent2d.position = vector2(Float(position.x), Float(position.y))
    }
    
    func getPosition() -> CGPoint
    {
        guard let sprite = component(ofType: SpriteComponent.self) else { return CGPoint.zero }
        return sprite.node.position
    }
    
    func spawnGreep() -> Greep
    {
        spawnedGreeps += 1
        let greep = Greep( ship: self, number: spawnedGreeps )
        return greep
    }
}
