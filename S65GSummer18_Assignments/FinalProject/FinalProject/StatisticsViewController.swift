//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var aliveValue: UILabel!
    @IBOutlet weak var bornValue: UILabel!
    @IBOutlet weak var emptyValue: UILabel!
    @IBOutlet weak var diedValue: UILabel!
    
    
    var aliveCount: Int = 0
    var bornCount: Int = 0
    var emptyCount: Int = 0
    var diedCount: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aliveValue.text = "0"
        self.bornValue.text = "0"
        self.emptyValue.text = "0"
        self.diedValue.text = "0"
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateStats(notified:)), name: GridChangeNoticationName, object: nil)
        nc.addObserver(self, selector: #selector(resetStats(notified:)), name: GridResetNoticationName, object: nil)
    }
    
    @objc func gridEditorExtractor(){
        let size = StandardEngine.onlyInstance.rows
        let totalPositions = positionSequence(from: (row:0, col:0), to: (row: size, col: size))
        totalPositions.forEach{ pos in
            
            switch StandardEngine.onlyInstance.grid[pos.row, pos.col]{
            case .alive:
                self.aliveCount += 1
            case .born:
                self.bornCount +=  1
            case .empty:
                self.emptyCount +=  1
            case .died:
                self.diedCount += 1
            }
        }
    }
    
    @objc func updateStats(notified: Notification){
        self.gridEditorExtractor()
        
        self.aliveValue.text = "\(aliveCount)"
        self.bornValue.text = "\(bornCount)"
        self.emptyValue.text = "\(emptyCount)"
        self.diedValue.text = "\(diedCount)"
    }
    
    
    @objc func resetStats(notified: Notification){
        self.aliveValue.text = "0"
        self.bornValue.text = "0"
        self.emptyValue.text = "0"
        self.diedValue.text = "0"
        
        self.aliveCount = 0
        self.bornCount = 0
        self.emptyCount = 0
        self.diedCount = 0
    }
    
    
    
}
















