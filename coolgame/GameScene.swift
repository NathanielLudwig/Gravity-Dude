//
//  GameScene.swift
//  coolgame
//
//  Created by 90303054 on 12/3/18.
//  Copyright © 2018 90303054. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var button = SKSpriteNode()
    var body = SKSpriteNode()
    var leftarm = SKSpriteNode()
    var rightarm = SKSpriteNode()
    var leftleg = SKSpriteNode()
    var rightleg = SKSpriteNode()
    var levelmap:SKTileMapNode = SKTileMapNode()
    var touchleftarm = false
    var touchrightarm = false
    var touchleftleg = false
    var touchrightleg = false
    var touchposition = CGPoint()
    var arms = [SKSpriteNode]()
    var button2 = SKSpriteNode()
    var newgame: Bool = false
    var dudetexture : SKTexture = SKTexture(imageNamed: "New Piskel-2.png-2")
    var armcolor : UIColor = #colorLiteral(red: 0.9450980425, green: 0.8392156959, blue: 0.4352941215, alpha: 1)
    
    override func didMove(to view: SKView) {
        
        
        //imports sprites from sks file
        body = self.childNode(withName: "body") as! SKSpriteNode
        leftarm = body.childNode(withName: "arm_left") as! SKSpriteNode
        rightarm = body.childNode(withName: "arm_right") as! SKSpriteNode
        leftleg = body.childNode(withName: "leg_left") as! SKSpriteNode
        rightleg = body.childNode(withName: "leg_right") as! SKSpriteNode
        button = camera?.childNode(withName: "button") as! SKSpriteNode
        button2 = camera?.childNode(withName: "button2") as! SKSpriteNode
        body.physicsBody?.usesPreciseCollisionDetection = true
        arms = [leftarm, rightarm, leftleg, rightleg]
        body.texture = dudetexture
        //creates physicsbody on arms and legs centered on anchor point
        for arm in arms{
            arm.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: arm.size.width, height: arm.size.height), center: CGPoint(x: arm.size.width / 2 - (arm.size.width * arm.anchorPoint.x), y: arm.size.height / 2 - (arm.size.height * arm.anchorPoint.y)))
            arm.physicsBody?.usesPreciseCollisionDetection = true
            arm.physicsBody?.mass = 10
            arm.physicsBody?.restitution = 1
            //leftarm.physicsBody?.affectedByGravity = false
            arm.physicsBody?.allowsRotation = true
            let armjoint = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: body.physicsBody!, anchor: body.convert(arm.position, to: self))
            
            arm.physicsBody?.categoryBitMask = UInt32(1)
            arm.physicsBody?.collisionBitMask = UInt32(2)
            arm.physicsBody?.contactTestBitMask = UInt32(2)
            arm.physicsBody?.friction = 0.75
            arm.physicsBody?.angularDamping = 0.75
            arm.physicsBody?.linearDamping = 0.75
            arm.color = armcolor
            self.physicsWorld.add(armjoint)
            
        }
        
        
        //creates tilemap reference
        for node in self.children {
            if node.name == "map" {
                levelmap = node as! SKTileMapNode
            }
        }
        
        
        //adds joints to physicsworld
        if newgame == false {
        if let x = UserDefaults.standard.object(forKey: "posx"){
            body.position.x = x as! CGFloat
            print(x)
        }
        if let y = UserDefaults.standard.object(forKey: "posy"){
            body.position.y = y as! CGFloat
            print(y)
        }
        if let rotation = UserDefaults.standard.object(forKey: "posy"){
                body.zRotation = rotation as! CGFloat
                print(rotation)
        }
        }
        physicsWorld.contactDelegate = self
        givePhysicsBody(map: levelmap)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchrightleg = false
        touchleftleg = false
        touchrightarm = false
        touchleftarm = false
        for arm in arms{
            arm.physicsBody!.mass = 10
            arm.physicsBody!.restitution = 1
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchposition = (touch.location(in: self))
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchposition = (touches.first?.location(in: self))!
        if button.contains((touches.first?.location(in: camera!))!){
             //UserDefaults.standard.set(body.position, forKey: "pos")
            if self.physicsWorld.gravity.dy < 0 {
            self.physicsWorld.gravity.dy = 10.0
                //camera?.zRotation = CGFloat.pi
                camera?.run(SKAction.rotate(toAngle: CGFloat.pi, duration: 0.5))
            } else{
            self.physicsWorld.gravity.dy = -10.0
            //camera?.zRotation = 0
            camera?.run(SKAction.rotate(toAngle: 0, duration: 0.5))
            }
           
        }
        if button2.contains((touches.first?.location(in: camera!))!){
            if physicsWorld.speed == 1.0 {
            self.physicsWorld.speed = 0.25
            } else {
            self.physicsWorld.speed = 1.0
            body.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
        }
        let touchinbody = (touches.first?.location(in: body))
        if leftarm.contains(touchinbody!){
            touchleftarm = true
        }
        
        if rightarm.contains(touchinbody!){
            touchrightarm = true
        }
        if leftleg.contains(touchinbody!){
            touchleftleg = true
        }
        if rightleg.contains(touchinbody!){
            touchrightleg = true
        }
        
    }
    func updatearms(arm: SKSpriteNode){
        arm.zRotation = atan2(touchposition.y - body.convert(arm.position, to: self).y
            , touchposition.x - body.convert(arm.position, to: self).x) + CGFloat.pi/2 - body.zRotation
        //arm.physicsBody!.mass = 100
        arm.physicsBody?.restitution = 3
    }
    override func update(_ currentTime: TimeInterval) {
        saveData()
        if body.position.y > 12800 {
            body.position = CGPoint(x: -9303, y: -11234)
            let gameScene = GameScene(fileNamed: "victory")
            gameScene?.scaleMode = .aspectFill
            
            view!.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 2))
        }
        // Called before each frame is rendered
        camera?.position = body.position
        if touchleftarm {
            //changes rotation of arms point to touchlocation
            updatearms(arm: leftarm)
        }
        if touchrightarm {
            updatearms(arm: rightarm)
        }
        if touchleftleg {
            updatearms(arm: leftleg)
        }
        if touchrightleg {
            updatearms(arm: rightleg)
        }
       
    }
    func saveData(){
        UserDefaults.standard.set(body.position.x, forKey: "posx")
        UserDefaults.standard.set(body.position.y, forKey: "posy")
        UserDefaults.standard.set(body.zRotation, forKey: "bodyrotation")
    }
    func givePhysicsBody(map: SKTileMapNode){
        let map = map
        
        let halfheight = CGFloat(map.numberOfRows) / 2.0 * map.tileSize.height
        let halfwidth = CGFloat(map.numberOfColumns) / 2.0 * map.tileSize.width
        for col in 0 ..< map.numberOfColumns {
            for row in 0..<map.numberOfRows {
                //sets tiledefinion for each row and col
                let tiledefintion = map.tileDefinition(atColumn: col, row: row)
                let lefttile = map.tileDefinition(atColumn: col - 3, row: row)
                let righttile = map.tileDefinition(atColumn: col + 3, row: row)
                let uptile = map.tileDefinition(atColumn: col, row: row - 3)
                let downtile = map.tileDefinition(atColumn: col, row: row + 3)
                //get position for each tile
                let x = CGFloat(col) * map.tileSize.width - halfwidth + (map.tileSize.width / 2)
                let y = CGFloat(row) * map.tileSize.height - halfheight + (map.tileSize.height / 2)
                if ((lefttile?.name == nil || righttile?.name == nil || uptile?.name == nil || downtile?.name == nil) && tiledefintion != nil/*(tiledefintion?.name!.contains("stuff"))!*/) {
            
                    //create physicsbody if tile is snow
                    
                    let tilesprite = SKSpriteNode(color: UIColor.clear, size: map.tileSize)
                    tilesprite.position = CGPoint(x: x, y: y)
                    tilesprite.physicsBody = SKPhysicsBody(rectangleOf: map.tileSize)
                    tilesprite.physicsBody?.affectedByGravity = false
                    //tilesprite.physicsBody?.pinned = true
                    tilesprite.physicsBody?.isDynamic = false
                    tilesprite.physicsBody?.allowsRotation = false
                    tilesprite.physicsBody?.categoryBitMask = UInt32(2)
                    tilesprite.physicsBody?.collisionBitMask = UInt32(1)
                    tilesprite.physicsBody?.restitution = 1
                    tilesprite.physicsBody?.contactTestBitMask = UInt32(1)
                    //tilesprite.physicsBody?.mass = 1000
                    //tilesprite.physicsBody?.usesPreciseCollisionDetection = true
                    tilesprite.physicsBody?.usesPreciseCollisionDetection = true
                    self.addChild(tilesprite)
                }
               
            }
            
        }
        
    }
    
    
    
    
    
}
