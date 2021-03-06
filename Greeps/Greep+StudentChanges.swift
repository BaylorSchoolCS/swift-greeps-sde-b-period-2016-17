//
//  Greep+StudentChanges.swift
//  Greeps
//
//  Created by the 2016-17 Software Design and Engineering class at Baylor School.
//  Jackson Bush, Charlie Collins, Jason Green, Cam King, Ben Workinger
//  Copyright © 2017 Baylor School Computer Science. All rights reserved.
//

import Foundation
import GameplayKit

extension Greep
{
    enum State
    {
        case Searching, AtEdge, AtWater, ReturningHome, Waiting, AvoidingObstacle, GatheringInformation, SharingInformation, ReturningToPile
        //add in up to four more states
    }
    
    // This function gets called at the end of the Greep init() 
    func studentInitialization()
    {
        
    }
    
    // This function gets called when this greep comes in contact with the edge
    func contactedEdge()
    {
        perform(behavior: ReturnHomeGreepBehavior(ship: ship), forMilliseconds: 2000, withState: .AvoidingObstacle, postState: .Searching, postBehavior: DefaultGreepBehavior())
    }
    
    // This function gets called when this greep comes in contact with the water
    func contactedWater(_ water: GKPolygonObstacle)
    {
//         add obstacle to memory
//        if !memory.contains( information: Information(info: water)!) && (memory.infoInSlot(0) == nil || memory.infoInSlot(1) == nil)
//        {
//            gatherInformationAbout(obstacle: water, postState: .ReturningHome, postBehavior: ReturnHomeGreepBehavior(ship: ship) )
//        }
        if isCarryingTomato
        {
            perform(behavior: MoveToRandomDirectionGreepBehavior(), forMilliseconds: 1000, withState: .AvoidingObstacle, postState: .ReturningHome, postBehavior: ReturnHomeGreepBehavior(ship: ship) )
        }
//        else if direction != nil
//        {
//            perform(behavior: MoveToDirectionGreepBehavior(direction: (direction!.oppositeDirection())), forMilliseconds: 1000, withState: .AvoidingObstacle, postState: state, postBehavior: MoveToDirectionGreepBehavior(direction: direction!))
//        }
        else
        {
            perform(behavior: MoveToRandomDirectionGreepBehavior(), forMilliseconds: 3000, withState: .AvoidingObstacle, postState: .ReturningHome, postBehavior: DefaultGreepBehavior() )
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
        if memory.hasEmptySlot(), let info = Information(info: pile)
        {
            memory.add(information: info)
        }
        behavior = ReturnHomeGreepBehavior(ship: ship)
        // load tomato
        // head home
        // define next state
        // define next behavior
    }
    
    // This function gets called when this greep comes in contact with another greep
    func contactedGreep( _ otherGreep: Greep )
    {
        shareInformationWith(otherGreep, postState: .Searching, postBehavior: DefaultGreepBehavior())
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
    
    // This function gets called after the tomato has been unloaded at the ship
    func postUnloadTomato()
    {
        for info in memory.allInfo()
        {
            if info.isTomato, let pile = info.info as? GKAgent
            {                
                behavior = MoveToPile(tomatoPile: pile)
                state = .ReturningToPile
                return
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
