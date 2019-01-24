//
//  Start.swift
//  coolgame
//
//  Created by 90303054 on 1/8/19.
//  Copyright © 2019 90303054. All rights reserved.
//


import SpriteKit
import GameplayKit
var startbutton = SKSpriteNode()
var keepgoing = SKSpriteNode()
var burrito = SKSpriteNode()
var banana = SKSpriteNode()
var burritoarrow = SKSpriteNode()
var bananaarrow = SKSpriteNode()
let gameScene = GameScene(fileNamed: "GameScene")
class Start: SKScene{

    override func didMove(to view: SKView) {
        startbutton = self.childNode(withName: "StartButton") as! SKSpriteNode
        keepgoing = self.childNode(withName: "keepgoing") as! SKSpriteNode
        burrito = self.childNode(withName: "burrito") as! SKSpriteNode
        banana = self.childNode(withName: "banana") as! SKSpriteNode
        burritoarrow = self.childNode(withName: "burritoarrow") as! SKSpriteNode
        bananaarrow = self.childNode(withName: "bananaarrow") as! SKSpriteNode
    }
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if startbutton.contains((touches.first?.location(in: self))!){
            //let gameScene = GameScene(fileNamed: "GameScene")
            gameScene?.scaleMode = .aspectFill
            gameScene?.newgame = true
            view!.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 2))
           
            
            
        }
        if keepgoing.contains((touches.first?.location(in: self))!){
            //let gameScene = GameScene(fileNamed: "GameScene")
            gameScene?.scaleMode = .aspectFill
            
            view!.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 2))
            gameScene?.newgame = false
        }
        if burrito.contains((touches.first?.location(in: self))!){
            
            gameScene?.dudetexture = SKTexture(imageNamed: "New Piskel-2.png-2")
            burritoarrow.isHidden = false
            gameScene?.armcolor = #colorLiteral(red: 0.9450980392, green: 0.8392156863, blue: 0.4352941176, alpha: 1)
            
            bananaarrow.isHidden = true
        }
        if banana.contains((touches.first?.location(in: self))!){
            gameScene?.dudetexture = SKTexture(imageNamed: "sprite_2")
            gameScene?.armcolor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            burritoarrow.isHidden = true
            
            bananaarrow.isHidden = false
        }
        
    }



}
