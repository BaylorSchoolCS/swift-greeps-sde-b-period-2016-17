//
//  GameScene.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var ship: Ship = Ship()
    var greepsToSpawn = [Greep]()
    
    let greepDelayInterval: TimeInterval = 0.5
    private var lastUpdateTime : TimeInterval = 0
    private var lastGreepAddTime: TimeInterval = 0
    
    var turnHomeTimer: TimeInterval = 10
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if greepsToSpawn.count > 0 && currentTime - lastGreepAddTime > greepDelayInterval
        {
            let greep = greepsToSpawn.removeFirst()
            entities.append(greep)
            addChild(greep.sprite!)
            lastGreepAddTime = currentTime
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        turnHomeTimer -= dt
        // Update entities
        for entity in self.entities {
            if turnHomeTimer <= 0
            {
                if let greep = entity as? Greep
                {
                    greep.state!.enter(ReturningHomeState.self)
                }
            }
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func addShipToScene( at location: CGPoint, withGreepCount numberOfGreeps:Int )
    {
        ship.setPosition(position: location)
        greepsToSpawn = ship.spawnGreeps(count: numberOfGreeps)
        entities.append(ship)
        addChild(ship.sprite!)
    }
}
