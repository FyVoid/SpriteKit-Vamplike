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
    ("monster1", 2)
]

class EnemyGenerator {
    var randomPositionX = GKRandomDistribution(lowestValue: -200, highestValue: Int(sceneY) + 200)
    var randomPositionY = GKRandomDistribution(lowestValue: 0, highestValue: 1)
    var randomEnemy = GKRandomDistribution(lowestValue: 0, highestValue: EnemyTypeInfo.count - 1)
    var enemies = Array<SKSpriteNode>()
    var generateCount = 0
    var baseGenerateCount = 1
    
    func genEnemy(scene: SKScene) {
        for _ in 0...generateCount {
            let enemyType = randomEnemy.nextInt()
            let enemyNode = SKSpriteNode(imageNamed: EnemyTypeInfo[enemyType].0)
            enemyNode.position = getRandomPosition()
            enemyNode.setScale(1)
            if enemyNode.position.x > sceneX / 2 {
                enemyNode.xScale = -1
            }
            enemyNode.zPosition = 9
            enemyNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyNode.size.width * 0.3, height: enemyNode.size.height * 0.3))
            enemyNode.physicsBody?.affectedByGravity = false
            enemyNode.physicsBody?.categoryBitMask = CBitmask.enemy
            enemyNode.physicsBody?.contactTestBitMask = CBitmask.player | CBitmask.playerFire | CBitmask.protect
            enemyNode.physicsBody?.collisionBitMask = CBitmask.player | CBitmask.playerFire | CBitmask.protect
            
            enemies.append(enemyNode)
            scene.addChild(enemyNode)
            
//            let moveAction = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2), duration: 5)
//            let removeAction = SKAction.removeFromParent()
//            let removeFromArray = SKAction.run {
//                self.removeNode(enemyNode: enemyNode)
//            }
//            let combinedAction = SKAction.sequence([moveAction, removeAction, removeFromArray])
//            enemyNode.run(combinedAction)
        }
    }
    
    func moveAllEnemies(target: CGPoint) {
        for enemy in enemies {
            
            var moveAction = SKAction.move(to: target, duration: 4)
            
            if pointDistance(pointA: target, pointB: enemy.position) < 300 {
                moveAction = SKAction.move(to: target, duration: 2)
            }
            
            enemy.zRotation = getRotation2Target(origin: enemy.position, target: target)
            
            enemy.run(moveAction)
        }
    }
    
    func removeAllNodes() {
        enemies = Array<SKSpriteNode>()
    }
    
    func getRandomPosition() -> CGPoint {
        return CGPoint(x: randomPositionX.nextInt(), y: randomPositionY.nextInt() * Int(sceneY))
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
            let dis = pointDistance(pointA: position, pointB: enemy.position)
            if dis < distance {
                closest = enemy.position
                distance = dis
            }
        }
        if pointDistance(pointA: closest, pointB: position) <= 1000 {
            return closest
        }
        return CGPointZero
    }
}
