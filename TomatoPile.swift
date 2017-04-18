//
//  TomatoPile.swift
//  Greeps
//
//  Created by Jason Oswald on 2017-04-13.
//  Copyright © 2017 CS. All rights reserved.
//

import Foundation
import GameplayKit

class TomatoPile: GKEntity
{
    var node: SKNode
    var tomatoCount: UInt8
    var previousCount: UInt8
    var agent = GKAgent2D()

    init( location: CGPoint, count: UInt8 )
    {
        tomatoCount = count
        previousCount = count
        let circle = SKShapeNode(circleOfRadius: CGFloat(count * 3))
        circle.fillColor = SKColor.red
        circle.strokeColor = SKColor.red
        node = circle
        super.init()
        node.position = location
        agent.position = float2(x:Float(location.x), y: Float(location.y))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
