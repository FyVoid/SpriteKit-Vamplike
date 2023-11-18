//
//  EnemyGenerator.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/17.
//

import Foundation
import GameKit
import SpriteKit

enum enemyTypeName: Int {
    case enemy1
}

var EnemyTypeInfo = [
    ("player-temp", 2)
]

class EnemyGenerator {
    var randomPositionX = GKRandomDistribution(lowestValue: 25, highestValue: 725)
    var randomPositionY = GKRandomDistribution(lowestValue: 0, highestValue: 1)
    var randomEnemy = GKRandomDistribution(lowestValue: 0, highestValue: EnemyTypeInfo.count - 1)
    var enemies = Array<SKSpriteNode>()
    
    func genEnemy(scene: SKScene) {
        let enemyType = randomEnemy.nextInt()
        var enemyNode = SKSpriteNode(imageNamed: EnemyTypeInfo[enemyType].0)
        enemyNode.position = getRandomPosition()
        enemyNode.setScale(6)
        enemyNode.zPosition = 9
        enemyNode.physicsBody = SKPhysicsBody(rectangleOf: enemyNode.size)
        enemyNode.physicsBody?.affectedByGravity = false
        enemyNode.physicsBody?.categoryBitMask = CBitmask.enemy
        enemyNode.physicsBody?.contactTestBitMask = CBitmask.player | CBitmask.playerFire | CBitmask.protect
        enemyNode.physicsBody?.collisionBitMask = CBitmask.player | CBitmask.playerFire | CBitmask.protect
        
        enemies.append(enemyNode)
        scene.addChild(enemyNode)
        
        var moveAction = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2), duration: 5)
        var removeAction = SKAction.removeFromParent()
        var removeFromArray = SKAction.run {
            self.removeNode(enemyNode: enemyNode)
        }
        var combinedAction = SKAction.sequence([moveAction, removeAction, removeFromArray])
        enemyNode.run(combinedAction)
    }
    
    func getRandomPosition() -> CGPoint {
        return CGPoint(x: randomPositionX.nextInt(), y: randomPositionY.nextInt() * 1335)
    }
    
    func removeNode(enemyNode: SKSpriteNode) {
        if self.enemies.isEmpty {
            return
        }
        for count in 0...(self.enemies.count - 1) {
            if self.enemies[count] === enemyNode {
                self.enemies.remove(at: count)
                return
            }
        }
    }
    
    func getClosestEnemyPosition(position: CGPoint) -> CGPoint {
        var closest = CGPoint(x: 0, y: 0)
        if enemies.isEmpty {
            return closest
        }
        var distance = pointDistance(pointA: position, pointB: closest)
        for enemy in enemies {
            var dis = pointDistance(pointA: position, pointB: enemy.position)
            if dis < distance {
                closest = enemy.position
                distance = dis
            }
        }
        return closest
    }
}
