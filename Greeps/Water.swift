//
//  Water.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
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
