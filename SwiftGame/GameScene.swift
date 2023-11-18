//
//  GameScene.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import GameKit
import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background = SKSpriteNode(imageNamed: "background-temp")
    
    var joystick = Joystick(backgroundSpriteName: "player-temp", stickSpriteName: "bullet-temp")
    
    let playerRespawnPoint = CGPoint(x: 750 / 2, y: 1335 / 2)
    var player = PlayerCharacter(spriteName: "player-temp", fireSpriteName: "bullet-temp")
    
    var fireTarget = CGPoint(x: 114, y: 514)
    var fireTimer = Timer()
    var fireInterval = 0.5
    
    var enemyGenerator = EnemyGenerator()
    var enemyGenerateTimer = Timer()
    var enemyGenerateInterval = 3.0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.setScale(6)
        background.zPosition = 1
        addChild(background)
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        camera = cameraNode
        
        joystick.makeJoystick(scene: scene!)
        
        player.makePlayer(scene: scene!)
        fireTimer = .scheduledTimer(timeInterval: fireInterval, target: self, selector: #selector(playerFire), userInfo: nil, repeats: true)
        
        enemyGenerateTimer = .scheduledTimer(timeInterval: enemyGenerateInterval, target: self, selector: #selector(genEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if joystick.appear {
            player.move(dir: joystick.getNormDir())
            // camera?.position = player.playerNode.position
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask <= contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.enemy {
            
            fireHitEnemy(fireNode: contactA.node as! SKSpriteNode, enemyNode: contactB.node as! SKSpriteNode)
            
        }
    }
    
    func fireHitEnemy(fireNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        fireNode.removeFromParent()
        enemyNode.removeFromParent()
        enemyGenerator.removeNode(enemyNode: enemyNode)
    }
    
    @objc func playerFire() {
        fireTarget = enemyGenerator.getClosestEnemyPosition(position: player.playerNode.position)
        if fireTarget.x == 0 && fireTarget.y == 0 {
            return
        }
        player.fire(scene: scene!, target: fireTarget)
    }
    
    @objc func genEnemy() {
        enemyGenerator.genEnemy(scene: scene!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let beginTouch = touches.first else {
            return
        }
        joystick.appear(position: beginTouch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            joystick.moveStick(position: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.disappear()
    }
    
}
