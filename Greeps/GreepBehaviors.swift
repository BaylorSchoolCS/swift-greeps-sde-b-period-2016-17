//
//  GreepBehaviors.swift
//  Greeps
//
//  Created by Jason Oswald on 4/3/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class DefaultGreepBahaviour: GKBehavior
{
    override init() {
        super.init()
        removeAllGoals()
        setWeight(1.0, for: GKGoal(toWander: Greep.defaultSpeed))
    }
    
    override var description: String
    {
        return "default"
    }
}

class ReturnHomeGreepBehavior: GKBehavior
{
    init( ship: Ship )
    {
        super.init()
        setWeight(0.1, for: GKGoal(toWander: Greep.wanderAmount))
        setWeight(1.0, for: GKGoal(toSeekAgent: ship.agent))
    }
    
    override var description: String
    {
        return "going home"
    }
}

// add other behaviors here

