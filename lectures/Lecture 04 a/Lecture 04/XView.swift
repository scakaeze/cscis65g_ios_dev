//
//  XView.swift
//  Lecture 04
//
//  Created by Stephen Akaeze on 7/13/18.
//  Copyright © 2018 Stephen Akaeze. All rights reserved.
//

import UIKit

typealias Position = (row: Int, col: Int)

func positions(rows: Int, cols: Int) -> [Position] {
    return (0 ..< rows)
        .map { zip( [Int](repeating: $0, count: cols) , 0 ..< cols ) }
        .flatMap { $0 }
        .map { Position(row: $0.0,col: $0.1) }
}

@IBDesignable class XView: UIView {

    @IBInspectable var lineColor: UIColor = .lightGray
    @IBInspectable var aliveColor: UIColor = .green
    @IBInspectable var deadColor: UIColor = .black
    @IBInspectable var size: Int = 10
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
       
        let horizontalSpacing  = rect.size.width/CGFloat(size)
        let verticalSpacing  = rect.size.height/CGFloat(size)
        
        let horizontalXStart = rect.origin.x
        let horizontalXEnd = rect.origin.x + rect.size.width
        
        let verticalYStart = rect.origin.y
        let verticalYEnd = rect.origin.y + rect.size.height
        
        // Horizontal lines
        (0...size).forEach { index in
            
            let yStart = (CGFloat(index) * verticalSpacing) + rect.origin.y
            let startPoint = CGPoint(x: horizontalXStart, y: yStart)
            let yEnd = yStart
            let endPoint = CGPoint(x: horizontalXEnd, y: yEnd)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.lineWidth = lineWidth
            horizontalPath.move(to: startPoint)
            horizontalPath.addLine(to: endPoint)
            lineColor.setStroke()
            horizontalPath.stroke()
        }
        
        (0...size).forEach { index in
           
            let xStart =    (CGFloat(index) * horizontalSpacing) + rect.origin.x
            let startPoint = CGPoint(x: xStart, y: verticalYStart)
            let xEnd = xStart
            let endPoint = CGPoint(x: xEnd, y: verticalYEnd)
            
            let verticalPath = UIBezierPath()
            verticalPath.lineWidth = lineWidth
            verticalPath.move(to: startPoint)
            verticalPath.addLine(to: endPoint)
            lineColor.setStroke()
            verticalPath.stroke()
        }
        
        let positionArray = positions(rows: size, cols: size)
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * verticalSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * horizontalSpacing) + rect.origin.y
            let cellRect = CGRect(
                x: xOrigin ,
                y: yOrigin ,
                width: verticalSpacing,
                height: horizontalSpacing
            )
            
            let path = UIBezierPath(ovalIn: cellRect)
            aliveColor.setFill()
            path.fill()
            
        }
    }
 

}




