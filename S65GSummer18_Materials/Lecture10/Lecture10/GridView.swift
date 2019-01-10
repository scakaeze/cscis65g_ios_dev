//
//  XView.swift
//  Lecture06
//
//  Created by Van Simmons on 7/16/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

protocol GridViewDataSource {
    subscript (pos: GridPosition) -> CellState { get set }
    var size: Int { get set }
}

@IBDesignable class GridView: UIView {
    
    @IBInspectable var lineColor: UIColor = .lightGray
    @IBInspectable var aliveColor: UIColor = .green
    @IBInspectable var bornColor: UIColor = .green
    @IBInspectable var diedColor: UIColor = .green
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var size: Int = 10 {
        didSet {
            dataSource?.size = size
        }
    }
    
    @IBInspectable var inset = CGFloat(2.0)
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    var dataSource: GridViewDataSource?
    
    fileprivate func drawLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        lineColor.setStroke()
        path.stroke()
    }
    
    fileprivate func drawCircle(row: Int, col: Int, rect: CGRect) {
        guard let dataSource = dataSource else { return }
        var color: UIColor = .clear
        switch dataSource[(row,col)] {
        case .alive: color = aliveColor
        case .born: color = bornColor
        case .died: color = diedColor
        case .empty: color = emptyColor
        }
        
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }
    
    fileprivate func drawLines(rect: CGRect,
                               hSpacing: CGFloat, hStart: CGFloat, hEnd: CGFloat,
                               vSpacing: CGFloat, vStart: CGFloat, vEnd: CGFloat)
    {
        // Horizontal lines
        (0 ... size).forEach { index in
            let x = (CGFloat(index) * hSpacing) + rect.origin.x
            let y = (CGFloat(index) * vSpacing) + rect.origin.y
            
            var startPoint = CGPoint(x: hStart, y: y)
            var endPoint = CGPoint(x: hEnd, y: y)
            drawLine(from: startPoint, to: endPoint)
            
            startPoint = CGPoint(x: x, y: vStart)
            endPoint = CGPoint(x: x, y: vEnd)
            drawLine(from: startPoint, to: endPoint)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(
            x: rect.origin.x + (lineWidth/2.0),
            y: rect.origin.y + (lineWidth/2.0),
            width: rect.size.width - lineWidth,
            height: rect.size.height - lineWidth
        )
        let hSpacing = rect.size.width / CGFloat(size)
        let hStart = rect.origin.x
        let hEnd = rect.origin.x + rect.size.width
        
        let vSpacing = rect.size.height / CGFloat(size)
        let vStart = rect.origin.y
        let vEnd = rect.origin.y + rect.size.height
        
        drawLines(rect: rect,
                  hSpacing: hSpacing, hStart: hStart, hEnd: hEnd,
                  vSpacing: vSpacing, vStart: vStart, vEnd: vEnd)
        
        // Cells
        let positionArray = positionSequence(from: (0,0), to: (size,size))
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * vSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * hSpacing) + rect.origin.y
            //let cellRect = CGRect( x: xOrigin, y: yOrigin, width: verticalSpacing, height: horizontalSpacing)
            
            let cellRect = CGRect(
                x: xOrigin + inset + (lineWidth / 2.0),
                y: yOrigin  + inset + (lineWidth / 2.0),
                width: vSpacing - ((2.0 * inset) + (lineWidth)),
                height: hSpacing - ((2.0 * inset) + (lineWidth))
            )
            
            drawCircle(row: row, col: col, rect: cellRect)
        }
    }
    
    func convert(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        let touch = touches.first!
        
        let touchY = touch.location(in: self).y - (lineWidth/2.0)
        let gridHeight = frame.size.height - lineWidth
        let row = touchY / gridHeight * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (lineWidth/2.0)
        let gridWidth = frame.size.width - lineWidth
        let col = touchX / gridWidth * CGFloat(size)
        
        let pos = GridPosition(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        return pos
    }
    
    func redisplay(position pos: GridPosition) {
        guard dataSource != nil else { return }
        let state = dataSource![pos].isAlive ? CellState.empty : CellState.alive
        dataSource![pos] = state
        lastPosition = pos
        setNeedsDisplay()
    }
    
    var lastPosition: GridPosition?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pos = convert(touches: touches) else { return }
        redisplay(position: pos)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pos = convert(touches: touches) else { return }
        guard pos.row != lastPosition?.row || pos.col != lastPosition?.col else { return }
        redisplay(position: pos)
    }
}
