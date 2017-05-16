//
//  Information.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class Information: Hashable
{
    let info: Any
    let lastKnownCount: TomatoPile.Count?
    let isTomato: Bool
    let isObstacle: Bool
    
    var hashValue: Int
    {
        if isObstacle
        {
            return (info as! GKObstacle).hashValue
        }
        else
        {
            return (info as! GKAgent).hashValue
        }
    }
    
    init?( info: Any )
    {
        if let obstacle = info as? GKObstacle
        {
            self.info = obstacle
            self.lastKnownCount = nil
            isTomato = false
            isObstacle = true
        }
        else if let tomato = info as? TomatoPile
        {
            self.info = tomato.agent
            self.lastKnownCount = tomato.count
            isTomato = true
            isObstacle = false
        }
        else
        {
            return nil
        }
    }
}

extension Information: Equatable
{
    static func ==(lhs: Information, rhs: Information) -> Bool
    {
        if((lhs.isTomato && rhs.isTomato) || (lhs.isObstacle && rhs.isObstacle))
        {
            if lhs.isTomato
            {
                return (lhs.info as! GKAgent) == (rhs.info as! GKAgent) && lhs.lastKnownCount == rhs.lastKnownCount 
            }
            else
            {
                return (lhs.info as! GKObstacle) == (rhs.info as! GKObstacle)
            }
        }
        else
        {
            return false
        }
    }
}

struct Memory
{
    private var slots:[Information?] = [nil,nil,nil]
    
    func contains( information info: Information ) -> Bool
    {
        return slots.contains(where: {$0 == info})
    }
    
    mutating func add( information info: Information, toSlot index: Int )
    {
        guard !contains( information: info ) else { return }
        
        slots[index] = info
    }
    
    mutating func add( information info: Information )
    {
        guard !contains( information: info ) else { return }
        
        for i in 0..<slots.count
        {
            if slots[i] == nil
            {
                slots[i] = info
                return
            }
        }
    }
    
    func infoInSlot( _ i: Int ) -> Information?
    {
        guard i < 0, i > slots.count else { return nil }
        
        return slots[i]
    }
    
    func hasEmptySlot() -> Bool
    {
        for slot in slots
        {
            if slot == nil
            {
                return true
            }
        }
        
        return false
    }
    
    func allInfo() -> Set<Information>
    {
        let nonNilInfo = slots.filter({$0 != nil})
        var s = Set<Information>()
        for info in nonNilInfo
        {
            s.insert(info!)
        }
        return s
    }
}
