//
//  victory.swift
//  coolgame
//
//  Created by 90303054 on 1/15/19.
//  Copyright © 2019 90303054. All rights reserved.
//


import SpriteKit
import GameplayKit

class victory: SKScene{
    var newgame = SKSpriteNode()
    override func didMove(to view: SKView) {
        
        newgame = self.childNode(withName: "newgame") as! SKSpriteNode
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newgame.contains((touches.first?.location(in: self))!){
            let gameScene = GameScene(fileNamed: "Start")
            gameScene?.scaleMode = .aspectFill
            
            view!.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 2))
            
        }
    }



}
