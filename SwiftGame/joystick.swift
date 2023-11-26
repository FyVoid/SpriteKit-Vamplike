//
//  joystick.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import GameKit
import SpriteKit

struct Joystick {
    let maxDistance = 100.0
    var backgroundSpriteName: String
    var stickSpriteName: String
    var backgroundNode: SKSpriteNode
    var stickNode: SKSpriteNode
    var appear = false
    
    init(backgroundSpriteName: String, stickSpriteName: String, _ backgroundNode: SKSpriteNode = SKSpriteNode(), _ stickNode: SKSpriteNode = SKSpriteNode()) {
        self.backgroundSpriteName = backgroundSpriteName
        self.stickSpriteName = stickSpriteName
        self.backgroundNode = backgroundNode
        self.stickNode = stickNode
        disappear()
    }
    
    mutating func makeJoystick(scene: SKScene) {
        backgroundNode = SKSpriteNode(imageNamed: backgroundSpriteName)
        stickNode = SKSpriteNode(imageNamed: stickSpriteName)
        backgroundNode.zPosition = 20
        stickNode.zPosition = 21
        backgroundNode.setScale(1.5)
        stickNode.setScale(3)
        backgroundNode.alpha = 0
        stickNode.alpha = 0
        backgroundNode.position = CGPoint(x: 100, y: 100)
        stickNode.position = CGPoint(x: 100, y: 100)
        scene.addChild(backgroundNode)
        scene.addChild(stickNode)
    }
    
    mutating func appear(position: CGPoint) {
        backgroundNode.position = position
        stickNode.position = position
        backgroundNode.alpha = 1
        stickNode.alpha = 1
        appear = true
    }
    
    mutating func moveStick(position: CGPoint) {
        if pointDistance(pointA: position, pointB: backgroundNode.position) < maxDistance {
            stickNode.position = position
        } else {
            stickNode.position = getOutPosition(endPosition: position)
        }
    }
    
    mutating func disappear() {
        backgroundNode.alpha = 0
        stickNode.alpha = 0
        appear = false
    }
    
    func getOutPosition(endPosition: CGPoint) -> CGPoint {
        var endX = endPosition.x - backgroundNode.position.x
        var endY = endPosition.y - backgroundNode.position.y
        var dis = pointDistance(pointA: endPosition, pointB: backgroundNode.position)
        endX /= dis
        endY /= dis
        return CGPoint(x: backgroundNode.position.x + endX * maxDistance, y: backgroundNode.position.y + endY * maxDistance)
        
    }
    
    func getNormDir() -> CGVector {
        if backgroundNode.position.x == stickNode.position.x
            && backgroundNode.position.y == stickNode.position.y 
        {
            return CGVector()
        }
        return normDir(pointA: backgroundNode.position, pointB: stickNode.position)
    }
    
    func moveBy(offset: CGPoint) {
        backgroundNode.position = CGPoint(
            x: backgroundNode.position.x - offset.x,
            y: backgroundNode.position.y - offset.y
        )
        
        stickNode.position = CGPoint(
            x: stickNode.position.x - offset.x,
            y: stickNode.position.y - offset.y
        )
    }
}
