//
//  OptionView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/12/6.
//

import SwiftUI

struct OptionView: View {
    @Binding var config: [String: Double]
    @State var enemySlider = 1.0
    @State var upgradeSlider = 1.0
    var body: some View {
        VStack {
            Text("敌人生成速度倍速")
                .font(.title)
                .foregroundColor(.red)
                .shadow(radius: 10)
            Slider(value: $enemySlider, in: 1.0...10.0)
                .frame(width: 300)
        }
        VStack {
            Text("升级需要经验倍数")
                .font(.title)
                .foregroundColor(.orange)
                .shadow(radius: 10)
            Slider(value: $upgradeSlider, in: 1.0...10.0)
                .frame(width: 300)
        }
        Button("save") {
            config["enemyGenerateAlpha"] = enemySlider
            config["upgradeAlpha"] = upgradeSlider
        }
        .font(.title)
        .frame(width: 200, height: 50)
        .background(.gray)
        .cornerRadius(10)
        .shadow(radius: 10)
        .foregroundColor(.black)
    }
}
