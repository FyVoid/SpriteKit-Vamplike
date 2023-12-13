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
    
    @State var paused = false
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    scene.config = config
                }
                .opacity(paused || scene.gameEnd ? 0.3 : 1.0)
            
            // UI
            VStack {
                if !(paused || scene.gameEnd) {
                    Hud(hp: $scene.player.hp, zombieKilled: $scene.zombieKilled, level: $scene.player.level, upgradeAlpha: $scene.upgradeAlpha)
                }
                if scene.showUpgradeView {
                    UpgradeView(upgrades: scene.upgrades, scene: scene)
                }
                
                if !(paused || scene.gameEnd) {
                    HStack {
                        Spacer()
                        Button("Pause") {
                            paused.toggle()
                            scene.pause()
                        }
                        .font(.title2)
                        .frame(width: 60, height: 40)
                        .background(.gray)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .foregroundColor(.black)
                    }
                }
            }
            
            if paused {
                VStack {
                    Text("Z Defender")
                    .font(.system(size: 56))
                    .bold()
                    .foregroundColor(.red)
                    .shadow(radius: 10)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button("Continue") {
                        paused.toggle()
                        scene.unPause()
                    }
                    .font(.title)
                    .frame(width: 200, height: 50)
                    .background(.gray)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.black)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button("Restart") {
                        scene.restart()
                        paused.toggle()
                    }
                    .font(.title)
                    .frame(width: 200, height: 50)
                    .background(.gray)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.black)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button("Back to menu") {
                        start.toggle()
                    }
                    .font(.title)
                    .frame(width: 200, height: 50)
                    .background(.gray)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundColor(.black)
                    
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
