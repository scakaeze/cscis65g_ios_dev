//
//  ConfigurationTableViewController.swift
//  FinalProject
//
//  Created by Stephen Akaeze on 8/4/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit


class ConfigurationTableViewController: UITableViewController {
    
    private let ConfigurationURL = "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1"
    var fetcher = Fetcher()
    var configurations: [Configuration]!
    var tempIndexPath:IndexPath = IndexPath.init(row: 0, section: 0)// preserves current indexPath object between performSegue() & prepare(forSegue:)
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        nc.addObserver(self, selector: #selector(newRow(notified:)), name: newRowNoticationName, object: nil) //Sender: InstrumentationView add button
        nc.addObserver(self, selector: #selector(newSavedGrid(notified:)), name: GridSavedNoticationName, object: nil) //Sender: SimulationView Save button
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch()
    }
    
    

    
    @objc func fetch(){
        guard let url = URL(string: ConfigurationURL) else { return }
        fetcher.fetch(url: url) { (response) in
            let op = BlockOperation {
                switch response {
                case .success(let data):
                    do {
                        self.configurations = try JSONDecoder().decode([Configuration].self, from: data)
                        self.tableView.reloadData()
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let msg):
                    print("\(msg)")
                }
            }
            OperationQueue.main.addOperation(op)
        }
    }
    
    // Adds empty row to table
    @objc func newRow(notified: Notification) {
        let newEmptyRow = Configuration (title: "Click to Create New Config", contents: nil)
        self.configurations.append(newEmptyRow)
        self.tableView.reloadData()
        
    }
    
    //Adds current simulation configuration to table view
    @objc func newSavedGrid(notified: Notification) {
        if let data = notified.userInfo as? [String: Configuration]{
            self.configurations.append(data["newSavedGrid"]!)
            self.tableView.reloadData()
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (configurations ?? []).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration", for: indexPath)
        cell.textLabel?.text = configurations[indexPath.row].title ?? "Loading Data"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CONFIGURATION LIST"
    }
    
    
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.configurations.remove(at: indexPath.row)
            tableView.reloadData()
        }
    
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.tempIndexPath = indexPath
            self.performSegue(withIdentifier: "Edit", sender: self)
        }
        
        delete.backgroundColor = UIColor.magenta
        edit.backgroundColor = UIColor.orange
        
        return [delete, edit]
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Recover indexPath value as tableView(editActionsForRowAt:) returns nil for tableView.indexPathForSelectedRow
        var indexPathChecker:IndexPath! = self.tableView.indexPathForSelectedRow
        if (indexPathChecker == nil){
            indexPathChecker = tempIndexPath
        }
        
        guard let destination = segue.destination as? GridEditorViewController else { return }
        destination.incomingGridConfig = configurations[indexPathChecker.row]
        
        //According to the instructions, only published configurations are saved
        if (self.configurations[indexPathChecker.row].title == "Click to Create New Config"){
            self.configurations.remove(at: indexPathChecker.row)
            self.tableView.reloadData()
        }
    }
    

}
