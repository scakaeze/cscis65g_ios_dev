//
//  XView.swift
//  Lecture04
//
//  Created by Van Simmons on 7/9/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

let attributes = [
    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 40),
    NSAttributedStringKey.foregroundColor : UIColor.red
]

@IBDesignable class XView: UIView {

    @IBInspectable var lineColor: UIColor = .lightGray
    @IBInspectable var aliveColor: UIColor = .green
    @IBInspectable var deadColor: UIColor = .black
    @IBInspectable var size: Int = 10 {
        didSet {
            grid = Grid(size, size)
        }
    }

    @IBInspectable var inset = CGFloat(2.0)
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    var grid: Grid = Grid(10,10) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let rect = CGRect(
            x: rect.origin.x + (lineWidth/2.0),
            y: rect.origin.y + (lineWidth/2.0),
            width: rect.size.width - lineWidth,
            height: rect.size.height - lineWidth
        )
        let horizontalSpacing = rect.size.width / CGFloat(size)
        let horizontalXStart = rect.origin.x
        let horizontalXEnd = rect.origin.x + rect.size.width

        let verticalSpacing = rect.size.height / CGFloat(size)
        let verticalYStart = rect.origin.y
        let verticalYEnd = rect.origin.y + rect.size.height

        // Horizontal lines
        (0 ... size).forEach { index in
            let y = (CGFloat(index) * verticalSpacing) + rect.origin.y
            let startPoint = CGPoint(x: horizontalXStart, y: y)
            let endPoint = CGPoint(x: horizontalXEnd, y: y)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.lineWidth = lineWidth
            horizontalPath.move(to: startPoint)
            horizontalPath.addLine(to: endPoint)
            lineColor.setStroke()
            horizontalPath.stroke()
        }

        // Vertical lines
        (0 ... size).forEach { index in
            let x = (CGFloat(index) * horizontalSpacing) + rect.origin.x
            let startPoint = CGPoint(x: x, y: verticalYStart)
            let endPoint = CGPoint(x: x, y: verticalYEnd)
            
            let verticalPath = UIBezierPath()
            verticalPath.lineWidth = lineWidth
            verticalPath.move(to: startPoint)
            verticalPath.addLine(to: endPoint)
            lineColor.setStroke()
            verticalPath.stroke()
        }
        
        // Cells
        let positionArray = positionSequence(from: (0,0), to: (size,size))
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * verticalSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * horizontalSpacing) + rect.origin.y
            //let cellRect = CGRect( x: xOrigin, y: yOrigin, width: verticalSpacing, height: horizontalSpacing)
            
            let cellRect = CGRect(
                x: xOrigin + inset + (lineWidth / 2.0),
                y: yOrigin  + inset + (lineWidth / 2.0),
                width: verticalSpacing - ((2.0 * inset) + (lineWidth)),
                height: horizontalSpacing - ((2.0 * inset) + (lineWidth))
            )
            
            var color: UIColor = .clear
            switch grid[(row,col)] {
            case .alive, .born: color = aliveColor
            case .died, .empty: color = deadColor
            }
            
            let path = UIBezierPath(ovalIn: cellRect)
            color.setFill()
            path.fill()
        }
        
        // Some text
//        let string = "CSCI S65-G"
//        let stringSize = string.size(withAttributes: attributes)
//        let textRect = CGRect(
//            x: rect.origin.x + (rect.width - stringSize.width) / 2,
//            y: rect.origin.y + (rect.height - stringSize.height) / 2,
//            width: stringSize.width,
//            height: stringSize.height
//        )
//        string.draw(in: textRect, withAttributes: attributes )
    }
    
    func convert(touch: UITouch) -> Position? {
        let touchY = touch.location(in: self).y - (lineWidth/2.0)
        let gridHeight = frame.size.height - lineWidth
        let row = touchY / gridHeight * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (lineWidth/2.0)
        let gridWidth = frame.size.width - lineWidth
        let col = touchX / gridWidth * CGFloat(size)

        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        return pos
    }
    
    var lastPosition: Position?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        let state = grid[pos]
        grid[pos] = state.isAlive ? .empty : .alive
        lastPosition = pos
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        guard pos.row != lastPosition?.row || pos.col != lastPosition?.col else { return }
        let state = grid[pos]
        grid[pos] = state.isAlive ? .empty : .alive
        lastPosition = pos
        setNeedsDisplay()
    }
}
