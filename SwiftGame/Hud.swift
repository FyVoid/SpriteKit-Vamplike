//
//  Hud.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/27.
//

import SwiftUI

struct Hud: View {
    @Binding var hp: Int
    @Binding var zombieKilled: Int
    @Binding var level: Int
    @Binding var upgradeAlpha: Double
    var body: some View {
        VStack {
            HStack {
                Text("HP: \(hp)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 10.0)
                Text("Zomblie Killed: \(zombieKilled)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .padding(.horizontal, 10.0)
            }
            .shadow(radius: 10)
            ProgressView("Upgrade", value: Double(zombieKilled - getUpgradeExp(level: level - 1, alpha: upgradeAlpha)) * 100 / Double(getUpgradeExp(level: level, alpha: upgradeAlpha) - getUpgradeExp(level: level - 1, alpha:  upgradeAlpha)), total: 100)
                .progressViewStyle(ExpProgressViewStyle())
                .font(.title)
                .opacity(0.7)
                .frame(height: 40)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

struct ExpProgressViewStyle: ProgressViewStyle{
    let foregroundColor:Color
    let backgroundColor:Color
    init(foregroundColor:Color = .yellow, backgroundColor:Color = .clear){
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader{ proxy in
            ZStack(alignment:.topLeading){
            backgroundColor
            Rectangle()
                .fill(foregroundColor)
                .frame(width:proxy.size.width * CGFloat(configuration.fractionCompleted ?? 0.0))
            }.clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                    configuration.label
                        .foregroundColor(.orange)
            )
        }
    }
}

