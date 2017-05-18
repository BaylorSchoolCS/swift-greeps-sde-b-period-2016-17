//
//  Water.swift
//  Greeps
//
//  Created by the 2016-17 Software Design and Engineering class at Baylor School.
//  Jackson Bush, Charlie Collins, Jason Green, Cam King, Ben Workinger
//  Copyright © 2017 Baylor School Computer Science. All rights reserved.
//

import Foundation
import GameplayKit

struct Water
{
    var sprite:SKNode
    var obstacle:GKPolygonObstacle {
        return SKNode.obstacles(fromSpriteTextures: [sprite], accuracy: 0.5).first!
    }
}
