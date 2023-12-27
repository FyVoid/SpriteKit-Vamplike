//
//  OptionView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/12/6.
//

import SwiftUI

struct OptionView: View {
    @Binding var config: [String: Double]
    @Binding var showOptions: Bool
    @State var enemySlider = 1.0
    @State var upgradeSlider = 1.0
    @State var infinite = 0.0
    @State var str = "未启用"
    var body: some View {
        VStack {
            Text("敌人生成速度倍速:\(enemySlider)")
                .font(.title)
                .foregroundColor(.red)
                .shadow(radius: 10)
            Slider(value: $enemySlider, in: 1.0...10.0)
                .frame(width: 300)
        }
        VStack {
            Text("升级需要经验倍数:\(upgradeSlider)")
                .font(.title)
                .foregroundColor(.orange)
                .shadow(radius: 10)
            Slider(value: $upgradeSlider, in: 1.0...10.0)
                .frame(width: 300)
        }
        HStack {
            Text("无尽模式 " + str)
                .font(.title)
                .foregroundColor(infinite == 0.0 ? .orange : .red)
                .shadow(radius: 10)
            if infinite == 0 {
                Button("启用") {
                    infinite = 1.0
                    str = "已启用"
                }
                .font(.title)
                .frame(width: 140, height: 50)
                .background(.black)
                .cornerRadius(10)
                .shadow(radius: 10)
                .foregroundColor(.red)
            } else if infinite == 1.0 {
                Button("禁用") {
                    infinite = 0.0
                    str = "未启用"
                }
                .font(.title)
                .frame(width: 140, height: 50)
                .background(.gray)
                .cornerRadius(10)
                .shadow(radius: 10)
                .foregroundColor(.black)
            }
            
        }
        Button("保存") {
            config["enemyGenerateAlpha"] = enemySlider
            config["upgradeAlpha"] = upgradeSlider
            config["infinite"] = infinite
            showOptions.toggle()
        }
        .font(.title)
        .frame(width: 200, height: 50)
        .background(.gray)
        .cornerRadius(10)
        .shadow(radius: 10)
        .foregroundColor(.black)
    }
}
