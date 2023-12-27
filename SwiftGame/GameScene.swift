//
//  GameScene.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import GameKit
import SpriteKit

let sceneX = 1500.0
let sceneY = 2800.0


class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    let background = SKSpriteNode(imageNamed: "map")
    
    var joystick = Joystick(backgroundSpriteName: "joystick-background", stickSpriteName: "joystick-stick")
    
    let playerRespawnPoint = CGPoint(x: sceneX / 2, y: sceneY / 2)
    @Published var player = PlayerCharacter(spriteName: "player", fireSpriteName: "bullet1")
    
    var fireTarget = CGPoint(x: 114, y: 514)
    var fireTimer = Timer()
    
    var soundNode = SKNode()
    
    var enemyGenerator = EnemyGenerator()
    var enemyGenerateTimer = Timer()
    var enemyGenerateInterval = 3.0
    var enemyGenerateAlpha = 1.0
    
    var infiniteMode = false
    
    @Published var autoUpgrade = false
    
    @Published var zombieKilled = 0
    @Published var upgrades: [UpgradeType] = []
    @Published var showUpgradeView = false
    @Published var upgradeExp: Int = 0
    @Published var upgradeAlpha = 1.0
    
    @Published var gameFinish = false
    @Published var gameEnd = false
    
    var config: [String: Double] = [:]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        setBegin()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if joystick.appear {
            player.move(dir: joystick.getNormDir())
            cameraTrace(position: player.playerNode.position)
            // camera?.position = player.playerNode.position
        }
        
        // checkEnemyDistance()
        
        enemyGenerator.moveAllEnemies(target: player.playerNode.position)
        
        checkGameEnd()
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
            
            if contactA.node != nil && contactB.node != nil {
                fireHitEnemy(fireNode: contactA.node as! SKSpriteNode, enemyNode: contactB.node as! SKSpriteNode)
            }
            
        }
        
        if contactA.categoryBitMask == CBitmask.player && contactB.categoryBitMask == CBitmask.enemy {
            
            if contactB.node != nil {
                enemyHitPlayer(enemyNode: contactB.node as! SKSpriteNode)
            }
        }
    }
    
    func cameraTrace(position: CGPoint) {
        let limitX = 600.0
        let limitY = 1200.0
        var posX: CGFloat = position.x
        var posY: CGFloat = position.y
        
        if posX < 0 + limitX {
            posX = limitX
        } else if posX > sceneX - limitX {
            posX = sceneX - limitX
        }
        
        if posY < 0 + limitY {
            posY = limitY
        } else if posY > sceneY - limitY {
            posY = sceneY - limitY
        }
        
        let lastPos = camera!.position
        camera?.position = CGPoint(x: posX, y: posY)
        
        let offset = CGPoint(x: lastPos.x - camera!.position.x, y: lastPos.y - camera!.position.y)
        joystick.moveBy(offset: offset)
    }
    
    func enemyHitPlayer(enemyNode: SKSpriteNode) {
        player.hp -= 1
        player.playerNode.run(SKAction.playSoundFileNamed("small_explosion3.mp3", waitForCompletion: false))
        enemyNode.removeFromParent()
        
        let breakEffect = SKEffectNode(fileNamed: "break")
        breakEffect?.position = enemyNode.position
        breakEffect?.zPosition = 8
        breakEffect?.setScale(0.7)
        addChild(breakEffect!)
        
        enemyGenerator.removeNode(enemyNode: enemyNode)
    }
    
    func fireHitEnemy(fireNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        fireNode.removeFromParent()
        player.playerNode.run(SKAction.playSoundFileNamed("mini_bomb1.mp3", waitForCompletion: false))
        enemyNode.removeFromParent()
        
        let explodeEffect = SKEmitterNode(fileNamed: "explode")
        explodeEffect?.position = enemyNode.position
        explodeEffect?.zPosition = 8
        explodeEffect?.setScale(0.5)
        addChild(explodeEffect!)
        
        enemyGenerator.removeNode(enemyNode: enemyNode)
        
        incretKill()
        
        updateEnemyGenerator()
    }
    
    func updateEnemyGenerator() {
        enemyGenerator.generateCount = zombieKilled / 3 + Int(sqrt(Double(zombieKilled))) + enemyGenerator.baseGenerateCount
        enemyGenerator.generateCount = Int(enemyGenerateAlpha * Double(enemyGenerator.generateCount))
    }
    
    func incretKill() {
        zombieKilled += 1
        
        // upgrade player ability
        if zombieKilled >= getUpgradeExp(level: player.level, alpha: upgradeAlpha) {
            player.level += 1
            upgrades = player.getUpgrade()
            invalidateTimers()
            if !autoUpgrade {
                scene?.isPaused = true
                showUpgradeView = true
            } else {
                upgrade(type: upgrades[0])
            }
            upgradeExp = getUpgradeExp(level: player.level, alpha: upgradeAlpha)
        }
    }
    
//    func getUpgradeExp(level: Int) -> Int {
//        let x = Double(level)
//        return Int(x * x + 3 * x - 1)
//    }
    
    func upgrade(type: UpgradeType) {
        player.upgrade(type: type)
        fireTimer = .scheduledTimer(timeInterval: player.fireInterval, target: self, selector: #selector(playerFire), userInfo: nil, repeats: true)
        enemyGenerateTimer = .scheduledTimer(timeInterval: enemyGenerateInterval, target: self, selector: #selector(genEnemy), userInfo: nil, repeats: true)
        isPaused = false
        showUpgradeView = false
    }
    
    func pause() {
        scene?.isPaused = true
        invalidateTimers()
    }
    
    func unPause() {
        fireTimer = .scheduledTimer(timeInterval: player.fireInterval, target: self, selector: #selector(playerFire), userInfo: nil, repeats: true)
        enemyGenerateTimer = .scheduledTimer(timeInterval: enemyGenerateInterval, target: self, selector: #selector(genEnemy), userInfo: nil, repeats: true)
        isPaused = false
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
    
    func checkEnemyDistance() {
        for enemyNode in enemyGenerator.enemies {
            if enemyNode.position.y > 600 && enemyNode.position.y < 900 {
                player.hp -= 1
                enemyNode.removeFromParent()
                
                let breakEffect = SKEffectNode(fileNamed: "break")
                breakEffect?.position = enemyNode.position
                breakEffect?.zPosition = 8
                breakEffect?.setScale(0.7)
                addChild(breakEffect!)
                
                enemyGenerator.removeNode(enemyNode: enemyNode)
            }
        }
    }
    
    func checkGameEnd() {
        // gameEnd = true
        if player.hp <= 0 {
            gameEnd = true
            isPaused = true
        }
        
        if zombieKilled >= 1000 && !infiniteMode {
            gameFinish = true
            isPaused = true
        }
    }
    
    func loadConfig(config: [String: Double]) {
        for type in config.keys {
            if type == "enemyGenerateAlpha" {
                enemyGenerateAlpha = config[type]!
            }
            else if type == "upgradeAlpha" {
                upgradeAlpha = config[type]!
            }
            else if type == "infinite" {
                infiniteMode = config[type]! != 0.0
            }
        }
    }
    
    func setBegin() {
        loadConfig(config: config)
        
        scene?.size = CGSize(width: sceneX, height: sceneY)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.setScale(1)
        background.zPosition = 1
        addChild(background)
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        cameraNode.setScale(0.8)
        addChild(cameraNode)
        camera = cameraNode
        
        joystick.makeJoystick(scene: scene!)
        
        player = PlayerCharacter(spriteName: "player", fireSpriteName: "bullet1")
        player.makePlayer(scene: scene!)
        fireTimer = .scheduledTimer(timeInterval: player.fireInterval, target: self, selector: #selector(playerFire), userInfo: nil, repeats: true)
        
        enemyGenerateTimer = .scheduledTimer(timeInterval: enemyGenerateInterval, target: self, selector: #selector(genEnemy), userInfo: nil, repeats: true)
        enemyGenerator.removeAllNodes()
        enemyGenerator.baseGenerateCount = 1
        enemyGenerator.generateCount = 0
        
        zombieKilled = 0
        upgradeExp = getUpgradeExp(level: player.level, alpha: upgradeAlpha)
        gameEnd = false
        gameFinish = false
        autoUpgrade = false
        isPaused = false
        
        let bgm = SKAudioNode(fileNamed: "scifi.mp3")
        bgm.autoplayLooped = true
        addChild(bgm)
    }
    
    func invalidateTimers() {
        fireTimer.invalidate()
        enemyGenerateTimer.invalidate()
    }
    
    func restart() {
        invalidateTimers()
        
        removeAllChildren()
        
        setBegin()
        
        isPaused = false
    }
    
    func checkEnd() {
        if zombieKilled >= 1000 {
            gameFinish = true
        }
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
