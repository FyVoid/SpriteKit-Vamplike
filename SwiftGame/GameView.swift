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
                .opacity(paused || scene.gameEnd || scene.gameFinish ? 0.3 : 1.0)
            
            // UI
            VStack {
                if !(paused || scene.gameEnd || scene.gameFinish) {
                    Hud(hp: $scene.player.hp, zombieKilled: $scene.zombieKilled, level: $scene.player.level, upgradeAlpha: $scene.upgradeAlpha)
                }
                if scene.showUpgradeView {
                    UpgradeView(upgrades: scene.upgrades, scene: scene)
                }
                
                if !(paused || scene.gameEnd || scene.gameFinish) {
                    HStack {
                        Spacer()
                        HStack {
                            Button("自动升级") {
                                scene.autoUpgrade.toggle()
                            }
                            .font(.title2)
                            .frame(width: 160, height: 40)
                            .background(.gray)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .foregroundColor(scene.autoUpgrade ? .red : .black)
                            
                            Button("暂停") {
                                paused.toggle()
                                scene.pause()
                            }
                            .font(.title2)
                            .frame(width: 80, height: 40)
                            .background(.gray)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .foregroundColor(.black)
                        }
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
                    
                    Button("继续游戏") {
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
                    
                    Button("重新开始") {
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
                    
                    Button("返回标题") {
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
                    Button("重来!") {
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
                    
                    Button("返回标题") {
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
            
            if scene.gameFinish {
                VStack {
                    Text("你已经击杀了1000个敌人，坚持到了救援到达！")
                    .font(.title)
                    .frame(width: 300, height: 140)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    
                    Button("重来!") {
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
                    
                    Button("返回标题") {
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
