//
//  MoveComponent.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class MoveComponent: GKAgent2D
{
    let ship: Ship
    
    override var description: String
    {
        return "max: \(maxSpeed), s:\(speed), a:\(maxAcceleration), r:\(rotation), \(velocity), b\(behavior)"
    }
    
    init( ship: Ship )
    {
        self.ship = ship
        super.init()
        behavior = DefaultGreepBahaviour()
        speed = Greep.defaultSpeed
        maxSpeed = Greep.defaultSpeed
        maxAcceleration = Greep.defaultSpeed
        rotation = Float(Int(arc4random() % 360)) - 180.0
        radius = 10 //?
        mass = 1
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
