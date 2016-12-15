//
//  BreadthFirstSearch.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

@_transparent
public func breadthFirstSearch<P: Problem>(problem: P) throws -> Path<P.State> {
    return try breadthFirstSearch(problem: problem, observer: nil)
}

internal func breadthFirstSearch<P: Problem>(problem: P, observer: GraphSearchObserver<P.State>?) throws -> Path<P.State> {
    return try graphSearch(problem: problem, observer: observer) { frontier in
        precondition(!frontier.isEmpty, "Can't choose from an empty frontier")
        //Return the path with the least steps.
        return frontier.sorted { x, y in
            x.steps.count < y.steps.count
        }.first!
    }
}
