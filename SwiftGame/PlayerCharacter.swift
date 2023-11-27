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

let playerMaxHp = 3

class PlayerCharacter {
    
    var random = GKRandomDistribution(lowestValue: -100, highestValue: 100)
    
    var level: Int
    
    var spriteName = ""
    var fireSpriteName = ""
    var playerNode: SKSpriteNode
    var respawnPosition: CGPoint
    var fireCount: Int
    var backFireCount: Int
    var boomCount: Int
    var fireInterval: Double
    var fireTimer: Timer
    var velocity = 2.0
    var hp = playerMaxHp
    
    let limitX = 30.0
    let limitY = 30.0
    
    init(spriteName: String, _ respawnPosition: CGPoint = CGPoint(x: sceneX / 2, y: sceneY / 2), _ fireCount: Int = 1, backFireCount: Int = 0, boomCount: Int = 0, fireInterval: Double = 1.0, fireSpriteName: String) {
        self.level = 1
        self.spriteName = spriteName
        self.respawnPosition = respawnPosition
        self.fireCount = fireCount
        self.backFireCount = backFireCount
        self.boomCount = boomCount
        self.fireInterval = fireInterval
        self.fireSpriteName = fireSpriteName
        self.fireTimer = Timer()
        self.playerNode = SKSpriteNode()
    }
    
    func makePlayer(scene: SKScene){
        hp = playerMaxHp
        
        playerNode = SKSpriteNode(imageNamed: spriteName)
        playerNode.position = respawnPosition
        playerNode.zPosition = 10
        playerNode.setScale(1)
        playerNode.zRotation = toRadians(angle: 90)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerNode.size.width * 0.3, height: playerNode.size.height * 0.3))
        playerNode.physicsBody?.affectedByGravity = false
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.categoryBitMask = CBitmask.player
        playerNode.physicsBody?.contactTestBitMask = CBitmask.enemy
        playerNode.physicsBody?.collisionBitMask = CBitmask.enemy
        scene.addChild(playerNode)
    }
    
    func randNum() -> Double {
        return Double(random.nextInt()) / 100
    }
    
    @objc func fire(scene: SKScene, target: CGPoint) {
        let fireTarget = pointAdd(target, pointSub(target, playerNode.position))
        
        for _ in 0..<fireCount {
            let beginPos = playerNode.position
            var endPos: CGPoint
            if fireCount < 10 {
                endPos = CGPoint(x: fireTarget.x + randNum() * 50 * Double(fireCount), y: fireTarget.y + randNum() * 50 * Double(fireCount))
            } else {
                endPos = CGPoint(x: fireTarget.x + randNum() * 500, y: fireTarget.y + randNum() * 500)
            }
            scene.addChild(genFire(beginPos: beginPos, endPos: endPos))
        }
        
        for _ in 0..<backFireCount {
            let beginPos = playerNode.position
            let backPos = CGPoint(x: fireTarget.x + 2 * (beginPos.x - fireTarget.x), y: fireTarget.y + 2 * (beginPos.y - fireTarget.y))
            var endPos: CGPoint
            if backFireCount < 10 {
                endPos = CGPoint(x: backPos.x + randNum() * 50 * Double(backFireCount), y: backPos.y + randNum() * 50 * Double(backFireCount))
            } else {
                endPos = CGPoint(x: backPos.x + randNum() * 500, y: backPos.y + randNum() * 500)
            }
            
            scene.addChild(genFire(beginPos: beginPos, endPos: endPos))
        }
        
        playerNode.zRotation = getRotation2Target(origin: playerNode.position, target: target)
        
        let fireEffect = SKEmitterNode(fileNamed: "playerFire")
        fireEffect?.zPosition = 12
        let rotation = getRotation2Target(origin: playerNode.position, target: target)
        fireEffect?.zRotation = rotation
        
        let offset = 120.0
        let posX = CoreGraphics.sin(rotation) * offset + playerNode.position.x
        let posY = -CoreGraphics.cos(rotation) * offset + playerNode.position.y
        fireEffect?.position = CGPoint(x: posX, y: posY)
        scene.addChild(fireEffect!)
        
    }
    
    func genFire(beginPos: CGPoint, endPos: CGPoint) -> SKSpriteNode {
        let fireNode = SKSpriteNode(imageNamed: fireSpriteName)
        fireNode.position = beginPos
        fireNode.setScale(1)
        fireNode.zPosition = 9
        fireNode.zRotation = getRotation2Target(origin: beginPos, target: endPos)
        fireNode.physicsBody = SKPhysicsBody(rectangleOf: fireNode.size)
        fireNode.physicsBody?.affectedByGravity = false
        fireNode.physicsBody?.categoryBitMask = CBitmask.playerFire
        fireNode.physicsBody?.contactTestBitMask = CBitmask.enemy
        fireNode.physicsBody?.collisionBitMask = CBitmask.enemy
        
        let moveAction = SKAction.move(to: endPos, duration: 0.8)
        let delateAction = SKAction.removeFromParent()
        let combinedAction = SKAction.sequence([moveAction, delateAction])
        
        fireNode.run(combinedAction)
        
        return fireNode
    }
    
    func move(dir: CGVector) {
        var posX = playerNode.position.x + dir.dx * velocity
        if posX < 0 + limitX {
            posX = 0 + limitX
        } else if posX > sceneX - limitX {
            posX = sceneX - limitX
        }
        var posY = playerNode.position.y + dir.dy * velocity
        if posY < 0 + limitY {
            posY = 0 + limitY
        } else if posY > sceneY - limitY {
            posY = sceneY - limitY
        }
        playerNode.position = CGPoint(x: posX, y: posY)
    }
    
    func upgrade(type: UpgradeType) {
        switch (type) {
        case .addBullet:
            fireCount += 1
        case .backBullet:
            backFireCount += 1
        case .Boom:
            fireCount += 1
        case .fastShoot:
            fireInterval *= 0.8
        case .moreHealth:
            hp += 2
        case .moveFaster:
            velocity *= 1.2
        }
    }
    
    func getUpgrade() -> [UpgradeType] {
        var ret: [UpgradeType] = []
        for _ in 0...3 {
            var add = UpgradeType.allCases.randomElement()
            while ret.contains(add!) {
                add = UpgradeType.allCases.randomElement()
            }
            ret.append(add!)
        }
        return ret
    }
}
