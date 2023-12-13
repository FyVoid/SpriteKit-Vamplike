//
//  utils.swift
//  SwiftGame
//
//  Created by FyVoid F on 2023/11/16.
//

import Foundation
import GameKit

let pi = 3.1415926

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

func toRadians(angle: Double) -> Double {
    return angle / 180.0 * pi
}

func getAngle(origin: CGPoint, target: CGPoint) -> CGFloat {
    let relativeX = target.x - origin.x
    let relativeY = target.y - origin.y
    let distance = pointDistance(pointA: origin, pointB: target)
    if relativeX >= 0 && relativeY >= 0 {
        return acos(relativeY / distance)
    } else if relativeX > 0 && relativeY < 0 {
        return pi - acos(-relativeY / distance)
    } else if relativeX <= 0 && relativeY <= 0 {
        return pi + acos(-relativeY / distance)
    } else {
        return -acos(relativeY / distance)
    }
}

func getRotation2Target(origin: CGPoint, target: CGPoint) -> CGFloat {
    return toRadians(angle: 180) - getAngle(origin: origin, target: target)
}

func getRelativePosition(origin: CGPoint, offset: CGPoint, target: CGPoint) -> CGPoint {
    return CGPoint(
        x: target.x + origin.x - offset.x,
        y: target.y + origin.y - offset.y
    )
}

func pointAdd(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
}

func getUpgradeExp(level: Int, alpha: Double) -> Int {
    let x = Double(level)
    return Int(alpha * (x * x + 3 * x))
}

func pointSub(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}
