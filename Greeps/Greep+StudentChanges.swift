//
//  Greep+StudentChanges.swift
//  Greeps
//
//  Created by Jason Oswald on 4/18/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

extension Greep
{
    enum State
    {
        case Searching, ReturningHome, Waiting, AvoidingObstacle, GatheringInformation
        //add in up to four more states
    }
    
    func contactedEdge()
    {
        // do the edge avoiding behavior for 50 counts
    }
    
    func contactedWater(_ water: GKPolygonObstacle)
    {
        // add obstacle to memory
        if !memory.contains( information: Information(info: water)!) && (memory.infoInSlot(0) == nil || memory.infoInSlot(1) == nil)
        {
            gatherInformationAbout(obstacle: water, postState: .ReturningHome, postBehavior: ReturnHomeGreepBehavior(ship: ship) )
        }
    }
    
    func contactedShip()
    {
        
    }
    
    func contactedTomato()
    {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        updateTimers(deltaTime: seconds)
        switch state
        {
            case .Searching:
                if timer <= 0
                {
                    // do whatever
                }
                break
            case .ReturningHome:
                break
            case .Waiting:
                break
            case .AvoidingObstacle:
                break
            case .GatheringInformation:
                break
                // user-defined cases:
            
        }
    }
}
