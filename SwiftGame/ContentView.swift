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
                VStack {
                    HStack {
                        Text("HP: \(scene.player.hp)")
                            .font(.title)
                            .foregroundColor(Color.red)
                            .padding(.horizontal, 10.0)
                        Text("Zomblie Killed: \(scene.zombieKilled)")
                            .font(.title)
                            .foregroundColor(Color.red)
                            .padding(.horizontal, 10.0)
                    }
                    Spacer()
                }
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
