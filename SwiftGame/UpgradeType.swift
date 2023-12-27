//
//  UpgradeType.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/24.
//

import Foundation

enum UpgradeType: String, CaseIterable {
    case addBullet = "向前方射出一枚额外子弹"
    case backBullet = "向后方射出一枚额外子弹"
    case fastShoot = "增加所有子弹射速"
    case moreHealth = "获取两点生命值"
    case moveFaster = "增加角色移动速度"
}
