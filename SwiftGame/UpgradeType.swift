//
//  UpgradeType.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/24.
//

import Foundation

enum UpgradeType: String, CaseIterable {
    case addBullet = "shoot one more bullet from your front"
    case backBullet = "shoot one more bullet from your back"
    case Boom = "throw one more boom to your enemies"
    case fastShoot = "shoot all your weapons faster"
    case moreHealth = "get 2 health point"
    case moveFaster = "make your character move faster"
}
