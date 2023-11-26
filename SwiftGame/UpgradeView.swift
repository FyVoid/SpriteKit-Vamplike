//
//  UpgradeView.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/24.
//

import SwiftUI
import SpriteKit

var upgrades = [UpgradeType.fastShoot, UpgradeType.fastShoot, UpgradeType.Boom]

struct UpgradeView: View {
    @State var upgrades: [UpgradeType]
    @ObservedObject var scene: GameScene
    @State var selected = false
    var body: some View {
        VStack{
            ForEach(0..<3) {
                index in
                UpgradeStack(type: upgrades[index], selected: $selected, scene: scene)
                    .padding(5.0)
            }
        }
    }
}
