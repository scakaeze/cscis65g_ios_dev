//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        StandardEngine.onlyInstance.delegate = self
    }
    
    func engine(didUpdate: EngineProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    
    @IBAction func step(_ sender: Any) {
        StandardEngine.onlyInstance.grid = StandardEngine.onlyInstance.grid.next()
        StandardEngine.onlyInstance.refreshRate = 2.0 
    }
    
    subscript(pos: Position) -> CellState {
        get { return StandardEngine.onlyInstance.grid[pos] }
        set { StandardEngine.onlyInstance.grid[pos] = newValue }
    }
    
}

