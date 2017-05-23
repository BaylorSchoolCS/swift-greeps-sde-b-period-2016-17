//
//  GreepBehaviors.swift
//  Greeps
//
//  Created by the 2016-17 Software Design and Engineering class at Baylor School.
//  Jackson Bush, Charlie Collins, Jason Green, Cam King, Ben Workinger
//  Copyright © 2017 Baylor School Computer Science. All rights reserved.
//

import Foundation
import GameplayKit

class DefaultGreepBehavior: GKBehavior
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

class MoveToDirectionGreepBehavior: GKBehavior
{
    init( direction: Greep.Direction )
    {
        super.init()
        setWeight(1.0, for: GKGoal(toWander: Greep.wanderAmount ))
        setWeight(3.0, for: GKGoal(toSeekAgent: direction.agentForDirection()))
    }
}

class MoveToRandomDirectionGreepBehavior: GKBehavior
{
    override init() {
        super.init()
        setWeight(1.0, for: GKGoal(toWander: Greep.wanderAmount))
        setWeight(3.0, for: GKGoal(toSeekAgent: Greep.Direction.randomDirectionAgent()))
    }
    
    override var description: String
    {
        return "random corner"
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
