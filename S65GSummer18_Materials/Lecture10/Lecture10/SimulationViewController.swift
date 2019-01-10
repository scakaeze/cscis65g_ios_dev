//
//  FirstViewController.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    func engine(didUpdate: Engine) {
    
    }
    
    subscript(pos: GridPosition) -> CellState {
        get { return Engine.sharedInstance.grid[pos.row, pos.col] }
        set { Engine.sharedInstance.grid[pos.row, pos.col] = newValue }
    }
    
    var size: Int = 10
    

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        
        Engine.sharedInstance.delegate = self
        Engine.sharedInstance.updateClosure = { (engine:Engine) -> Void in
            self.gridView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(sender: UIButton) {
        // create configuration object from the grid
        // data should be your configuration object
        let data = "".data(using: .utf8)
        let recode = try! JSONEncoder().encode(<#T##value: Encodable##Encodable#>)
        let defaults = UserDefaults.standard
        defaults.set(recode, forKey: "simulationConfiguration")
        resultString = data.description + (String(data: recode, encoding: .utf8) ?? "could not reencode string")
        
    }
    
    
}

