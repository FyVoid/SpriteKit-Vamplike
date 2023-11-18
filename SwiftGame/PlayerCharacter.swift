//
//  PlayerCharacter.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import SpriteKit
import GameKit

enum FireType: Int {
    case normal
    case fire
    case frost
    case electricity
}

class PlayerCharacter {
    var spriteName = ""
    var fireSpriteName = ""
    var playerNode: SKSpriteNode
    var respawnPosition: CGPoint
    var fireCount: Int
    var fireTimer: Timer
    var velocity = 2.0
    
    let limitX = 200.0
    let limitY = 300.0
    
    init(spriteName: String, _ respawnPosition: CGPoint = CGPoint(x: 750 / 2, y: 1335 / 2), _ fireCount: Int = 1, fireSpriteName: String) {
        self.spriteName = spriteName
        self.respawnPosition = respawnPosition
        self.fireCount = fireCount
        self.fireSpriteName = fireSpriteName
        self.fireTimer = Timer()
        self.playerNode = SKSpriteNode()
    }
    
    func makePlayer(scene: SKScene){
        playerNode = SKSpriteNode(imageNamed: spriteName)
        playerNode.position = respawnPosition
        playerNode.zPosition = 10
        playerNode.setScale(6)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.affectedByGravity = false
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.categoryBitMask = CBitmask.player
        playerNode.physicsBody?.contactTestBitMask = CBitmask.enemy
        playerNode.physicsBody?.collisionBitMask = CBitmask.enemy
        scene.addChild(playerNode)
    }
    
    @objc func fire(scene: SKScene, target: CGPoint) {
        var fireNode = SKSpriteNode(imageNamed: fireSpriteName)
        fireNode.position = playerNode.position
        fireNode.setScale(5)
        fireNode.zPosition = 9
        fireNode.physicsBody = SKPhysicsBody(rectangleOf: fireNode.size)
        fireNode.physicsBody?.affectedByGravity = false
        fireNode.physicsBody?.categoryBitMask = CBitmask.playerFire
        fireNode.physicsBody?.contactTestBitMask = CBitmask.enemy
        fireNode.physicsBody?.collisionBitMask = CBitmask.enemy
        
        scene.addChild(fireNode)
        let moveAction = SKAction.move(to: target, duration: 1)
        let delateAction = SKAction.removeFromParent()
        let combinedAction = SKAction.sequence([moveAction, delateAction])
        
        fireNode.run(combinedAction)
        
    }
    
    func move(dir: CGVector) {
        var posX = playerNode.position.x + dir.dx * velocity
        if posX < 0 + limitX {
            posX = 0 + limitX
        } else if posX > 750 - limitX {
            posX = 750 - limitX
        }
        var posY = playerNode.position.y + dir.dy * velocity
        if posY < 0 + limitY {
            posY = 0 + limitY
        } else if posY > 1335 - limitY {
            posY = 1335 - limitY
        }
        playerNode.position = CGPoint(x: posX, y: posY)
    }
}
