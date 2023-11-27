//
//  ContentView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import SwiftUI
import SpriteKit
import GameKit

struct ContentView: View {
    @StateObject var scene: GameScene = {
        let scene = GameScene()
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            // UI
            VStack {
                Hud(hp: $scene.player.hp, zombieKilled: $scene.zombieKilled, level: $scene.player.level)
                if scene.showUpgradeView {
                    UpgradeView(upgrades: scene.upgrades, scene: scene)
                }
            }
            .alert("You are dead!", isPresented: $scene.gameEnd) {
                Button("Replay") {
                    scene.restart()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
