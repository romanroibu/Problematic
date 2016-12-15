//
//  UniformCostSearch.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

@_transparent
public func uniformCostSearch<P: Problem>(problem: P) throws -> Path<P.State>
    where P.Cost: UnsignedInteger {
    return try uniformCostSearch(problem: problem, observer: nil)
}

internal func uniformCostSearch<P: Problem>(problem: P, observer: GraphSearchObserver<P.State>?) throws -> Path<P.State>
    where P.Cost: UnsignedInteger {
    return try graphSearch(problem: problem, observer: observer) { frontier in
        precondition(!frontier.isEmpty, "Can't choose from an empty frontier")
        //Return the path with the cheapest cost.
        return frontier.sorted { x, y in
            problem.pathCost(of: x) < problem.pathCost(of: y)
        }.first!
    }
}
