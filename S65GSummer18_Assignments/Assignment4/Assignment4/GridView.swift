//
//  GridView.swift
//  Assignment4
//
//  Created by Stephen Akaeze on 7/25/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit


protocol GridViewDataSource {
    subscript (pos: Position) -> CellState { get set }
    //var size: Int { get set }
}


@IBDesignable class GridView: UIView {
    
    
    @IBInspectable var gridWidth: CGFloat = 2.0
    @IBInspectable var gridColor: UIColor = .lightGray
    @IBInspectable var buffer = CGFloat(2.0)
    
    @IBInspectable var bornColor:UIColor = .red
    @IBInspectable var livingColor: UIColor = .green
    @IBInspectable var diedColor: UIColor = .yellow
    @IBInspectable var emptyColor: UIColor = .blue
    @IBInspectable var size: Int = 10 {
        didSet {
            //dataSource?.size = size
        }
    }
    
    var dataSource: GridViewDataSource?
    
    // Draw Single Line
    fileprivate func drawLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        gridColor.setStroke()
        path.stroke()
    }
    
    //Draw Circle
    fileprivate func drawCircle(row: Int, col: Int, rect: CGRect) {
        guard let dataSource = dataSource else { return }
        var color: UIColor = .clear
        switch dataSource[(row,col)] {
        case .born: color = bornColor
        case .alive: color = livingColor
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
        (0 ... size).forEach { index in
            let x = (CGFloat(index) * hSpacing) + rect.origin.x
            let y = (CGFloat(index) * vSpacing) + rect.origin.y
            
            //horizontal line
            var startPoint = CGPoint(x: hStart, y: y)
            var endPoint = CGPoint(x: hEnd, y: y)
            drawLine(from: startPoint, to: endPoint)
            
            //Vertical line
            startPoint = CGPoint(x: x, y: vStart)
            endPoint = CGPoint(x: x, y: vEnd)
            drawLine(from: startPoint, to: endPoint)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(
            x: rect.origin.x + (gridWidth/2.0),
            y: rect.origin.y + (gridWidth/2.0),
            width: rect.size.width - gridWidth,
            height: rect.size.height - gridWidth
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
            
            let cellRect = CGRect(
                x: xOrigin + buffer + (gridWidth / 2.0),
                y: yOrigin  + buffer + (gridWidth / 2.0),
                width: vSpacing - ((2.0 * buffer) + (gridWidth)),
                height: hSpacing - ((2.0 * buffer) + (gridWidth))
            )
            
            drawCircle(row: row, col: col, rect: cellRect)
        }
    }
    
    func convert(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let touch = touches.first!
        
        let touchY = touch.location(in: self).y - (gridWidth/2.0)
        let gridHeight = frame.size.height - gridWidth
        let row = touchY / gridHeight * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (gridWidth/2.0)
        let temp = frame.size.width - gridWidth
        let col = touchX / temp * CGFloat(size)
        
        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        return pos
    }
    
    func redisplay(position pos: Position) {
        guard dataSource != nil else { return }
        let state = dataSource![pos].isAlive ? CellState.empty : CellState.alive
        dataSource![pos] = state
        lastPosition = pos
        setNeedsDisplay()
    }
    
    var lastPosition: Position?
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
