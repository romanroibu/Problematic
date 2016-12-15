//
//  Problem.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

/// Problem definition
public protocol Problem {
    associatedtype Cost
    associatedtype State

    typealias Action = (start: State, final: State)

    var initial: State { get }
    func actions(for state: State) -> [Action]
    func goalTest(_ state: State) -> Bool
    func stepCost(of action: Action) -> Cost
}

extension Problem where State: Hashable, Cost: UnsignedInteger {
    public func pathCost(of path: Path<State>) -> Cost {
        return path.actions.map(self.stepCost).reduce(0, +)
    }
}
