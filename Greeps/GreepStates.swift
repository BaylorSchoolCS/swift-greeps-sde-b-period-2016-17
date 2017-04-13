//
//  GreepStates.swift
//  Greeps
//
//  Created by Jason Oswald on 4/13/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class GreepBaseState: GKState
{
    var greep: Greep
    var associatedBehavior: GKBehavior = DefaultGreepBahaviour()
    
    init( greep: Greep )
    {
        self.greep = greep
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SearchingState.self ||
                stateClass == ReturningHomeState.self ||
                stateClass == WaitState.self ||
                stateClass == AtObstacleState.self //|| add your own states here
    }
    
    override func didEnter(from previousState: GKState?) {
        greep.updateBehaviorTo(associatedBehavior)
    }
}

class SearchingState: GreepBaseState
{
    
}

class ReturningHomeState: GreepBaseState
{
    override init( greep: Greep )
    {
        super.init(greep: greep)
        associatedBehavior = ReturnHomeGreepBehavior(ship: greep.ship)
    }
}

class WaitState: GreepBaseState
{
    
}

class AtObstacleState: GreepBaseState
{
    
}

extension Greep
{
    func initializeStates()
    {
        
    }
    
    func updateBehaviorTo( _ newBehaviour: GKBehavior )
    {
        guard let mover = component(ofType: MoveComponent.self) else { return }
        mover.behavior = newBehaviour
    }
}
