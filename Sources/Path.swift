//
//  Path.swift
//  Problematic
//
//  Created by Roman Roibu on 04/12/2016.
//  Copyright © 2016 Roman Roibu. All rights reserved.
//

//TODO: Don't enforce T to be Hashable
public struct Path<T: Hashable> {
    public typealias Node = T

    public let start: Node
    fileprivate var tail: [Node]

    public var end: Node {
        return self.tail.last ?? self.start
    }

    public var steps: [Node] {
        return [self.start] + self.tail
    }

    public var actions: [(Node, Node)] {
        return Array(zip(self.steps, self.tail))
    }

    public init(_ nodes: Node...) {
        var nodes = nodes
        precondition(!nodes.isEmpty)

        self.start = nodes.removeFirst()
        self.tail = nodes
    }

    public func contains(_ step: Node) -> Bool {
        return self.steps.contains(step)
    }

    public mutating func append(_ node: Node) {
        self.tail.append(node)
    }
}

extension Path: Equatable { //TODO: `where T: Equatable`
    public static func ==<T>(lhs: Path<T>, rhs: Path<T>) -> Bool {
        return lhs.steps == rhs.steps
    }
}

extension Path: Hashable { //TODO: `where T: Hashable`
    public var hashValue: Int {
        return self.tail.map { $0.hashValue }.reduce(self.start.hashValue, ^)
    }
}
