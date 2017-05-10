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
    static let delayQueue = DispatchQueue(label: "org.baylorschool.cs.greeps.delayqueue")
    var sceneCounter = 0
    let mapDataLocation = Bundle.main.url(forResource: "example", withExtension: "json")
    var maps:[[String:Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let data = try Data(contentsOf: mapDataLocation!)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            {
                maps = json["maps"] as? [[String:Any]]
            }
        } catch {
            print( "Error with JSON \(error)")
        }
        
        
        for i in 0..<10
        {
            GameViewController.delayQueue.asyncAfter(deadline: .now() + .milliseconds(10000*i)) {
                self.loadCurrentScene()
                self.sceneCounter += 1
            }
        }
    }
    
    func loadCurrentScene()
    {
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene"),
            let sceneJSON = maps?[sceneCounter],
            let sceneNode = scene.rootNode as! GameScene?
        {
            // Copy gameplay related content over to the scene
            sceneNode.entities = scene.entities
            sceneNode.graphs = scene.graphs
            
            // Set the scale mode to scale to fit the window
            sceneNode.scaleMode = .aspectFill
            // all of this comes from a json file representing the levels?
            
            sceneNode.addShip(at: CGPoint(x:sceneJSON["shipX"] as! Int,y:sceneJSON["shipY"] as! Int), withGreepCount: 10)
            let obstacles = sceneJSON["obstacles"] as! [[String:Any]]
            for obstacle in obstacles
            {
                let type = obstacle["type"] as! Int
                let location = CGPoint( x:obstacle["x"] as! Int, y:obstacle["y"] as! Int )
                let scale = obstacle["scale"] as! Float
                let rotation = obstacle["rotation"] as! Float
                sceneNode.addWater( ofType: "water\(type)", at: location, scaledBy:scale, rotatedBy: rotation)
            }
            let tomatoes = sceneJSON["tomatoes"] as! [[String:Any]]
            for tomato in tomatoes
            {
                let location = CGPoint( x:tomato["x"] as! Int, y:tomato["y"] as! Int )
                let count = tomato["count"] as! Int
                sceneNode.addTomatoPile(at: location, ofSize: UInt8(count) )
            }
            
            sceneNode.addScore()
            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(sceneNode)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = false
                view.showsNodeCount = false
                view.showsPhysics = true
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
