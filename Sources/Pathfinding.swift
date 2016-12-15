//
//  Pathfinding.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

public struct Pathfinding<T: Hashable>: Problem {
    public typealias Node = T
    public typealias Route = [Node: Cost]

    public typealias Cost = UInt
    public typealias State = Node
    public typealias Action = (start: Node, final: Node)

    public typealias GoalTest = (State) -> Bool
    public typealias StepCost = (Action) -> Cost

    fileprivate let _initial: State
    fileprivate let _actions: [Action]
    fileprivate let _goalTest: GoalTest
    fileprivate let _stepCost: StepCost

    internal init(initial: State, actions: [Action], goalTest: @escaping GoalTest, stepCost: @escaping StepCost) {
        self._initial  = initial
        self._actions  = actions
        self._goalTest = goalTest
        self._stepCost = stepCost
    }

    public init(initial: Node, final: Node, routes: [Node: Route]) {
        self.init(
            initial: initial,
            actions: routes.map { start, neighbours in
                neighbours.map { final, cost in (start: start, final: final) }
            }.reduce([], +),
            goalTest: { node in
                node == final
            },
            stepCost: { action in
                routes[action.start]?[action.final] ?? 0 // Cost.max //FIXME
            }
        )
    }

//MARK: Pathfinding+Problem

    public var initial: State {
        return self._initial
    }
    public func actions(for node: Node) -> [Action] {
        return self._actions.filter { node == $0.start }
    }
    public func goalTest(_ node: Node) -> Bool {
        return self._goalTest(node)
    }
    public func stepCost(of action: Action) -> Cost {
        return self._stepCost(action)
    }
}
