//
//  ContentView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import SwiftUI
import SpriteKit
import GameKit

struct GameView: View {
    @StateObject var scene: GameScene = {
        let scene = GameScene()
        return scene
    }()
    
    @Binding var start: Bool
    @Binding var config: [String: Double]
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    scene.config = config
                }
            
            // UI
            VStack {
                Hud(hp: $scene.player.hp, zombieKilled: $scene.zombieKilled, level: $scene.player.level, upgradeAlpha: $scene.upgradeAlpha)
                if scene.showUpgradeView {
                    UpgradeView(upgrades: scene.upgrades, scene: scene)
                }
            }
            
            if scene.gameEnd {
                VStack {
                    Button("Replay!") {
                        scene.restart()
                    }
                    .font(.title)
                    .frame(width: 300, height: 60)
                    .background(.red)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.black)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button("Back to menu") {
                        start.toggle()
                    }
                    .font(.title)
                    .frame(width: 300, height: 60)
                    .background(.red)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.black)
                    
                    Spacer()
                        .frame(height: 30)
                }
                .frame(width: .infinity, height: .infinity)
                .opacity(0.8)
                .foregroundColor(.red)
                .cornerRadius(10)
                .shadow(radius: 10)

            }
                
        }
    }
}
