//
//  Grid.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//
import Foundation

public typealias GridPosition = (row: Int, col: Int)
public typealias GridPositionSequence = [GridPosition]
public typealias GridSize = (rows: Int, cols: Int)

fileprivate func norm(_ val: Int, to size: Int) -> Int { return ((val % size) + size) % size }

public enum CellState {
    case alive, empty, born, died
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}

public protocol GridProtocol {
    init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState)
    var description: String { get }
    var size: GridSize { get }
    subscript (row: Int, col: Int) -> CellState { get set }
    func next() -> Self
}

public let lazyPositions = { (size: GridSize) in
    return (0 ..< size.rows)
        .lazy
        .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
        .flatMap { $0 }
        .map { GridPosition($0) }
}

// Provide a sequence of all positions in a range
public func positionSequence (from: GridPosition, to: GridPosition) -> GridPositionSequence {
    return (from.row ..< to.row)
        .map { row in zip( [Int](repeating: row, count: to.col - from.col), from.col ..< to.col ) }
        .flatMap { $0 }
}

let offsets: [GridPosition] = [
    (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
    (row:  0, col:  -1),                     (row:  0, col:  1),
    (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
]

extension GridProtocol {
    public var description: String {
        return lazyPositions(self.size)
            .map { (self[$0.row, $0.col].isAlive ? "*" : " ") + ($0.col == self.size.cols - 1 ? "\n" : "") }
            .joined()
    }
    
    private func neighborStates(of pos: GridPosition) -> [CellState] {
        return offsets.map { self[pos.row + $0.row, pos.col + $0.col] }
    }
    
    private func nextState(of pos: GridPosition) -> CellState {
        let iAmAlive = self[pos.row, pos.col].isAlive
        let numLivingNeighbors = neighborStates(of: pos).filter({ $0.isAlive }).count
        switch numLivingNeighbors {
        case 2 where iAmAlive,
             3: return iAmAlive ? .alive : .born
        default: return iAmAlive ? .died  : .empty
        }
    }
    
    public func next() -> Self {
        var nextGrid = Self(size.rows, size.cols) { _, _ in .empty }
        lazyPositions(self.size).forEach { nextGrid[$0.row, $0.col] = self.nextState(of: $0) }
        return nextGrid
    }
}

public struct Grid: GridProtocol {
    private var _cells: [[CellState]]
    public let size: GridSize
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }
    
    public init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState = { (arg) -> CellState in let (_, _) = arg; return .empty }) {
        _cells = [[CellState]](repeatElement( [CellState](repeatElement(.empty, count: rows)), count: cols))
        size = GridSize(rows, cols)
        lazyPositions(self.size).forEach { self[$0.row, $0.col] = cellInitializer($0) }
    }
}

extension Grid: Sequence {
    fileprivate var living: [GridPosition] {
        return lazyPositions(self.size).filter { return  self[$0.row, $0.col].isAlive   }
    }
    
    public struct GridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [GridPosition]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [GridPosition], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: GridProtocol
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> GridProtocol? {
            if history.hasCycle { return nil }
            let newGrid:Grid = grid.next() as! Grid
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> GridIterator { return GridIterator(grid: self) }
}

public extension Grid {
    public static func gliderInitializer(pos: GridPosition) -> CellState {
        switch pos {
        case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
        default: return .empty
        }
    }
}

let EngineNoticationName = Notification.Name(rawValue: "EngineUpdate")

typealias UpdateClosure = (Engine) -> Void

protocol EngineDelegate {
    func engine(didUpdate: Engine) -> Void
}

class Engine {
    static var sharedInstance: Engine = Engine()
    
    var size: Int = 10
    var grid: Grid = Grid(10,10)
    private var timer: Timer?
    
    
    var updateClosure: UpdateClosure = { _ in }
    var delegate: EngineDelegate?
    
    var interval: Double = 0 {
        didSet {
            timer?.invalidate()
            timer = nil
            if interval > 0 {
                timer = Timer.scheduledTimer(
                    withTimeInterval: interval,
                    repeats: true
                ) { (t: Timer) -> Void in
                    self.grid = self.grid.next()
                    self.updateClosure(self)
                    //                    self.delegate?.engine(didUpdate: self)
                    //                    let nc = NotificationCenter.default
                    //                    let info = ["engine": self]
                    //                    nc.post(name: EngineNoticationName, object: nil, userInfo:info)
                }
            }
        }
    }
}
