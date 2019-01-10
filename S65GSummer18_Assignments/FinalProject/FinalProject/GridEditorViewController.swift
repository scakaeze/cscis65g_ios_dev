//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Stephen Akaeze on 8/4/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

let GridPublishNoticationName = Notification.Name(rawValue: "GridPublish")

typealias updateGridSettings = () -> gridSettings


class GridEditorViewController: UIViewController, GridViewDataSource {
    
    subscript(pos: GridPosition) -> CellState {
        get {return self.instrumentationEngine.grid[pos.row, pos.col]}
        set {self.instrumentationEngine.grid[pos.row,pos.col] = newValue}
    }
    
    
    @IBOutlet weak var configTitle: UITextField!
    @IBOutlet weak var EditorGridView: GridView!
    
    var instrumentationEngine: StandardEngine! = nil
    var incomingGridConfig: Configuration!
    var newGridsettings: gridSettings!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nc.addObserver(self, selector: #selector(updateSettings(notified:)), name: sendGridSettings, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EditorGridView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.instrumentationEngine = StandardEngine(newGridsettings.gridSize, newGridsettings.gridSize)
        self.gridEditorPopulate()
        self.EditorGridView.size = newGridsettings.gridSize
        self.EditorGridView.setNeedsDisplay()
    }
    
    
    
    @objc func updateSettings(notified: Notification){
        if let data = notified.userInfo as? [String: gridSettings]{
            self.newGridsettings = data["newGridSettings"]
        }
    }
    
    
    
    @objc func gridEditorPopulate(){
        self.configTitle.text = incomingGridConfig.title == "Click to Create New Config" ? "Edit Config Name" : self.incomingGridConfig.title
        if (self.incomingGridConfig.contents != nil){
            self.incomingGridConfig.contents?.forEach{content in
                self.instrumentationEngine.grid[content[0],content[1]] =  CellState.alive
           }
        }
    }

  
   
    @IBAction func gridPublished(_ sender: UIButton) {
        self.instrumentationEngine.title = self.configTitle.text!
        self.instrumentationEngine.refreshRate = oldCurrentGridSettings.gridTimerRate
    
        let info = ["newGridRate": newGridsettings.gridTimerRate, "newGrid": self.instrumentationEngine] as [String : Any]
        nc.post(name: GridPublishNoticationName, object: nil, userInfo:info)
        
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
