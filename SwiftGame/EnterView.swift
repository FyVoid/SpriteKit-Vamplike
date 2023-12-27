//
//  EnterView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/12/6.
//

import SwiftUI

let pages: [HelpView.Page] = [
    HelpView.Page(imageName: "move", description: "在屏幕任何地方拖动摇杆来移动"),
    HelpView.Page(imageName: "shoot", description: "你的角色会自动攻击你的敌人"),
    HelpView.Page(imageName: "choose", description: "选择你的能力"),
    HelpView.Page(imageName: "kill", description: "击杀尽可能多的敌人！")
]

struct EnterView: View {
    @State var start = false
    @State var showOptions = false
    @State var showHelp = false
    @State var config: [String: Double] = [
        "enemyGenerateAlpha": 1.0,
        "upgradeAlpha": 1.0
    ]
    var body: some View {
        
        ZStack {
            if !start {
                NavigationView {
                    
                    VStack {
                        NavigationLink(destination: HelpView(pages: pages), isActive: $showHelp) {
                            EmptyView()
                        }
                        NavigationLink(destination: OptionView(config: $config, showOptions: $showOptions), isActive: $showOptions) {
                            EmptyView()
                        }
                        Text("Z Defender")
                            .font(.system(size: 56))
                            .bold()
                            .foregroundColor(.red)
                            .shadow(radius: 10)
                        Spacer()
                            .frame(height: 100.0)
                        
                        Button("开始!") {
                            start = true
                        }
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(.gray)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .foregroundColor(.black)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Button("设置") {
                            showOptions.toggle()
                        }
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(.gray)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .foregroundColor(.black)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Button("帮助") {
                            showHelp.toggle()
                        }
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(.gray)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .foregroundColor(.black)
                        
                        Spacer()
                            .frame(height: 30)
                    }
                }
            }
            
            if start {
                GameView(start: $start, config: $config)
            }
        }
    }
}

#Preview {
    EnterView()
}
