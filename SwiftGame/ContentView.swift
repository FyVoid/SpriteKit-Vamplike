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
     let scene = GameScene()
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
