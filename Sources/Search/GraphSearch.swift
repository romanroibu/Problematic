//
//  GraphSearch.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

public enum GraphSearchError: Error {
    case noSolution
}

internal typealias GraphSearchObserver<T: Hashable> = (GraphSearchStep<T>) -> Void

internal enum GraphSearchStep<State: Hashable> {
    case explored(State)
    case choosen(Path<State>)
    case foundGoal(Path<State>)
    case extendPath(Path<State>, with: State)
}

@_transparent
public func graphSearch<P: Problem>(problem: P, choose: (Set<Path<P.State>>) -> Path<P.State>) throws -> Path<P.State> {
    return try graphSearch(problem: problem, observer: nil, choose: choose)
}

internal func graphSearch<P: Problem>(problem: P, observer: GraphSearchObserver<P.State>?, choose: (Set<Path<P.State>>) -> Path<P.State>) throws -> Path<P.State> {
    var frontier = Set([Path(problem.initial)])
    var explored = Set<P.State>()

    while true {
        guard !frontier.isEmpty else {
            throw GraphSearchError.noSolution
        }

        var path = choose(frontier)
        frontier.remove(path)
        observer?(.choosen(path))

        let state = path.end
        explored.insert(state)
        observer?(.explored(state))

        guard !problem.goalTest(state) else {
            observer?(.foundGoal(path))
            return path
        }

        for action in problem.actions(for: state) {
            let unexplored = action.final
            let wasExplored = explored.contains(unexplored)
            let isFrontier  = frontier.first(where: { $0.contains(unexplored) }) != nil
            guard !wasExplored && !isFrontier else { continue }

            path.append(unexplored)
            frontier.insert(path)
            observer?(.extendPath(path, with: unexplored))
        }
    }
}
