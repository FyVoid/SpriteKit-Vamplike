//
//  UpgradeStack.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/24.
//

import SwiftUI
import SpriteKit


struct UpgradeStack: View {
    @State var type: UpgradeType
    @Binding var selected: Bool
    @ObservedObject var scene: GameScene
    var body: some View {
        VStack() {
            Text(type.rawValue)
                .font(.body)
                .fontWeight(.heavy)
            Spacer()
                .frame(height: 10.0)
            Text("选择")
            .font(.title3)
            .fontWeight(.heavy)
            .foregroundColor(.red)
        }
        .padding(.all, selected ? 0.0 : 10.0)
        .frame(width: 300.0, height: selected ? 10.0 : 100.0)
        .background(.gray)
        .cornerRadius(selected ? 0 : 30)
        .opacity(selected ? 0.0 : 0.9)
        .shadow(radius: selected ? 0 : /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1.0)) {
                selected.toggle()
                scene.upgrade(type: type)
            }
        }
    }
        
}
