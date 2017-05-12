//
//  GreepBehaviors.swift
//  Greeps
//
//  Created by Jason Oswald on 4/3/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class DefaultGreepBahavior: GKBehavior
{
    override init() {
        super.init()
        setWeight(1.0, for: GKGoal(toWander: Greep.wanderAmount))
    }
    
    override var description: String
    {
        return "default"
    }
}

class WaitGreepBehavior: GKBehavior
{
    override init() {
        super.init()
        setWeight(1.0, for: GKGoal(toReachTargetSpeed: 0 ))
    }
    
    override var description: String
    {
        return "waiting"
    }
}

class ReturnHomeGreepBehavior: GKBehavior
{
    init( ship: Ship )
    {
        super.init()
        setWeight(0.1, for: GKGoal(toWander: Greep.wanderAmount))
        setWeight(1.0, for: GKGoal(toReachTargetSpeed: Greep.defaultSpeed ))
        setWeight(1.0, for: GKGoal(toSeekAgent: ship.agent))
    }
    
    override var description: String
    {
        return "going home"
    }
}

class GatheringInformationBehavior: GKBehavior
{
    override init()
    {
        super.init()
        setWeight(1.0, for: GKGoal(toReachTargetSpeed: 0))
    }
    
    override var description: String
    {
        return "gathering information"
    }
}

// add other behaviors here

class GoToPileAndAvoidBehavior: GKBehavior
{
    init(tomatoPile: GKAgent, obstacles: [GKObstacle])
    {
        super.init()
        setWeight(1.0, for: GKGoal( toWander: Greep.wanderAmount ))
        setWeight(5.0, for: GKGoal(toSeekAgent: tomatoPile))
        setWeight(10.0, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 20))
    }
}

class GoAroundWaterBehavior: GKBehavior
{
    init(water: GKAgent)
    {
        super.init()
        setWeight(1.0, for: GKGoal(toWander: Greep.wanderAmount))
        setWeight(10.0, for: GKGoal(toSeparateFrom: [water], maxDistance: 20, maxAngle: 0))
    }
}

class MoveToPile: GKBehavior
{
    init(tomatoPile: GKAgent)
    {
        super.init()
//        setWeight(1.0, for: GKGoal( toWander: Greep.wanderAmount ))
        setWeight(10.0, for: GKGoal(toSeekAgent: tomatoPile))
    }
}
