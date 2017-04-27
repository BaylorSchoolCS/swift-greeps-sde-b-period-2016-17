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
        case Searching, ReturningHome, Waiting, AvoidingObstacle, GatheringInformation, SharingInformation
        //add in up to four more states
    }
    
    // This function gets called at the end of the Greep init() 
    func studentInitialization()
    {
        
    }
    
    // This function gets called when this greep comes in contact with the edge
    func contactedEdge()
    {
        updateBehaviorTo(ReturnHomeGreepBehavior(ship: ship))
        timer = 2
        state = .AvoidingObstacle
        nextState = .Searching
        nextBehavior = DefaultGreepBahaviour()
    }
    
    // This function gets called when this greep comes in contact with the water
    func contactedWater(_ water: GKPolygonObstacle)
    {
//         add obstacle to memory
        if !memory.contains( information: Information(info: water)!) && (memory.infoInSlot(0) == nil || memory.infoInSlot(1) == nil)
        {
            gatherInformationAbout(obstacle: water, postState: .ReturningHome, postBehavior: ReturnHomeGreepBehavior(ship: ship) )
        }
        
        
    }
    
    // This function gets called when this greep comes in contact with the ship
    func contactedShip()
    {
        
    }
    
    // This function gets called when this greep comes in contact with a tomato pile
    func contactedTomato( _ pile: TomatoPile )
    {
        loadTomatoFromPile(pile)
        updateBehaviorTo(ReturnHomeGreepBehavior(ship: ship))
        // load tomato
        // head home
        // define next state
        // define next behavior
    }
    
    // This function gets called when this greep comes in contact with another greep
    func contactedGreep( _ otherGreep: Greep )
    {
        shareInformationWith(otherGreep, postState: .Search, postBehavior: DefaultGreepBehavior())
//        print( "I, \(sprite?.physicsBody?.node?.name), contacted \(otherGreep.sprite?.physicsBody?.node?.name)")
//        rotate(delta: 50)
    }
    
    // This function gets called during shareInfromationWith
    // This is where you define what will happen with the information
    func exchangeInformationWith( _ otherGreep: Greep )
    {
        
    }
    
    // This function gets called when another greep shares information with this greep
    func postSharedWith()
    {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        updateTimers(deltaTime: seconds)
    }
}
