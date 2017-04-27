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
    
    func studentInitialization()
    {
        
    }
    
    
    func contactedEdge()
    {
        updateBehaviorTo(ReturnHomeGreepBehavior(ship: ship))
        timer = 2
        state = .AvoidingObstacle
        nextState = .Searching
        nextBehavior = DefaultGreepBahaviour()
    }
    
    func contactedWater(_ water: GKPolygonObstacle)
    {
//         add obstacle to memory
        if !memory.contains( information: Information(info: water)!) && (memory.infoInSlot(0) == nil || memory.infoInSlot(1) == nil)
        {
            gatherInformationAbout(obstacle: water, postState: .ReturningHome, postBehavior: ReturnHomeGreepBehavior(ship: ship) )
        }
        
        
    }
    
    func contactedShip()
    {
        
    }
    
    func contactedTomato( _ pile: TomatoPile )
    {
        loadTomatoFromPile(pile)
        updateBehaviorTo(ReturnHomeGreepBehavior(ship: ship))
        // load tomato
        // head home
        // define next state
        // define next behavior
    }
    
    func contactedGreep( _ otherGreep: Greep )
    {
//        print( "I, \(sprite?.physicsBody?.node?.name), contacted \(otherGreep.sprite?.physicsBody?.node?.name)")
//        rotate(delta: 50)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        updateTimers(deltaTime: seconds)
        switch state
        {
            case .Searching:
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
