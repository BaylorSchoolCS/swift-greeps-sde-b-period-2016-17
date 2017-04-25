//
//  GameViewController.swift
//  Greeps
//
//  Created by Jason Oswald on 3/31/17.
//  Copyright © 2017 CS. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                // all of this comes from a json file representing the levels?
                sceneNode.addChild(sceneNode.water)
                sceneNode.addShip(at: CGPoint(x:300,y:500), withGreepCount: 5)
                sceneNode.addWater( ofType: "water1", at: CGPoint(x:800,y:200), scaledBy:0.2, rotatedBy: 50)
                sceneNode.addTomatoPile(at: CGPoint( x:900, y:100), ofSize: 10 )
                sceneNode.addScore()
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true
                }
                
                
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
