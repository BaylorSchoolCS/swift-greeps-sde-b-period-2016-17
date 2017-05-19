//
//  Ship.swift
//  Greeps
//
//  Created by the 2016-17 Software Design and Engineering class at Baylor School.
//  Jackson Bush, Charlie Collins, Jason Green, Cam King, Ben Workinger
//  Copyright © 2017 Baylor School Computer Science. All rights reserved.
//

import Foundation
import GameplayKit

class Ship: GKEntity
{
    var scene: GameScene
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
    
    init( withScene scene: GameScene )
    {
        self.scene = scene
        super.init()
        let texture = SKTexture(imageNamed: "ship.png")
        let spriteComponent = SpriteComponent(texture: texture)
        spriteComponent.node.entity = self
        let physics = SKPhysicsBody(circleOfRadius: texture.size().width/5)
//        let physics = SKPhysicsBody(texture: texture, size: texture.size())
        physics.categoryBitMask = PhysicsCategory.ship.rawValue
        physics.affectedByGravity = false
        physics.isDynamic = false
        spriteComponent.node.physicsBody = physics
        addComponent(spriteComponent)
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
        let greep = Greep( ship: self )
        return greep
    }
    
    func addTomato()
    {
        scene.count += 1
        //print ("I returned a tomato")
    }
}
