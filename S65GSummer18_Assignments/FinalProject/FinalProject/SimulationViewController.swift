//
//  SimulationViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

let GridChangeNoticationName = Notification.Name(rawValue: "GridUpdate")
let GridSavedNoticationName = Notification.Name(rawValue: "GridSave")
let GridResetNoticationName = Notification.Name(rawValue: "GridReset")

class SimulationViewController: UIViewController,GridViewDataSource,EngineDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var GridView: GridView!
    var currentRefreshRate: Double = 0.0
    var newGridWasPublished: Bool = false
    var publishedConfig: Configuration!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nc.addObserver(self, selector: #selector(justPublished(notified:)), name: GridPublishNoticationName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GridView.dataSource = self
        StandardEngine.onlyInstance.delegate = self
        
        if (!(self.newGridWasPublished)){
            loadSavedGrid()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StandardEngine.onlyInstance.refreshRate = currentRefreshRate
        self.nameTextField.text = StandardEngine.onlyInstance.title
        self.GridView.size = StandardEngine.onlyInstance.rows
        self.GridView.setNeedsDisplay()
    }
    
    
    
    subscript(pos: GridPosition) -> CellState {
        get {return StandardEngine.onlyInstance.grid[pos.row, pos.col]}
        set {StandardEngine.onlyInstance.grid[pos.row, pos.col] = newValue}
    }
    
    func engine(didUpdate: StandardEngine) {
        self.GridView.setNeedsDisplay()
        
        let info = ["Gridchange": "update stats"]
        nc.post(name: GridChangeNoticationName, object: nil, userInfo: info)
    }
    
    
    @objc func justPublished(notified:Notification){
        if let data = notified.userInfo as? [String: Any]{
            self.currentRefreshRate = data["newGridRate"] as! Double
            StandardEngine.onlyInstance = data["newGrid"] as! StandardEngine
            self.newGridWasPublished = true
        }
       StandardEngine.onlyInstance.delegate = self
    }
    
    
    
    @objc func extractCurrentGridData(){
        let size = GridView.size
        var temp: [[Int]]? = [[]]
        let totalPositions = positionSequence(from: (row:0, col:0), to: (row: size, col: size))
        totalPositions.forEach{ pos in
            if (StandardEngine.onlyInstance.grid[pos.row , pos.col] == CellState.alive || StandardEngine.onlyInstance.grid[pos.row , pos.col] == CellState.born){
                temp!.append([pos.row,pos.col])
            }
        }
        temp!.remove(at: 0) // eliminated the empty 0th element
        self.publishedConfig = Configuration (title: nameTextField.text, contents: temp)
    }
    
    
    
    @IBAction func configSave(_ sender: UIButton) {
        StandardEngine.onlyInstance.refreshRate = 0.0
        extractCurrentGridData()
        self.GridView.setNeedsDisplay()
        
        let info = ["newSavedGrid": self.publishedConfig] as [String : Any]
        nc.post(name: GridSavedNoticationName, object: nil, userInfo: info)
        
        let recode = try! JSONEncoder().encode(self.publishedConfig)
        let defaults = UserDefaults.standard
        defaults.set(recode, forKey: "simulationConfiguration")
    }
    
    
    
    @IBAction func configReset(_ sender: UIButton) {
        let size = StandardEngine.onlyInstance.rows
        StandardEngine.onlyInstance.refreshRate = 0.0
        StandardEngine.onlyInstance = StandardEngine(size,size)
        self.GridView.setNeedsDisplay()
        self.nameTextField.text = ""
        
        let info = ["resetStats": "Reset grid and Stats"]
        nc.post(name: GridResetNoticationName, object: nil, userInfo: info)
    }
    
    
    @objc func loadSavedGrid(){
        if (lastSavedConfig != nil){
            StandardEngine.onlyInstance.title = lastSavedConfig.title!
            lastSavedConfig.contents?.forEach{content in
                StandardEngine.onlyInstance.grid[content[0],content[1]] =  CellState.alive
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    

}

