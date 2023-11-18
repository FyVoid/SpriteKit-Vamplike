//
//  utils.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import GameKit

func pointDistance(pointA: CGPoint, pointB: CGPoint) -> Double {
    return sqrt(((pointA.x - pointB.x) * (pointA.x - pointB.x)) + ((pointA.y - pointB.y) * (pointA.y - pointB.y)))
}

func normDir(pointA: CGPoint, pointB: CGPoint) -> CGVector {
    var dis = pointDistance(pointA: pointA, pointB: pointB)
    var ret = CGVector(dx: (pointB.x - pointA.x) / dis, dy: (pointB.y - pointA.y) / dis)
    return ret
}

struct CBitmask {
    static let player: UInt32 = 0b1
    static let playerFire: UInt32 = 0b10
    static let enemy: UInt32 = 0b100
    static let protect: UInt32 = 0b1000
}
