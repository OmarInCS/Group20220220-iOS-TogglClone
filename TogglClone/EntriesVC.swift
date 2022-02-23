//
//  EntriesVC.swift
//  TogglClone
//
//  Created by user on 2/21/22.
//

import UIKit

class EntriesVC: UIViewController {
    
    var tableData = TimeEntry.groupEntriesByStartDate(TimeEntry.dummyEntries)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension EntriesVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let idx = tableData.index(tableData.startIndex, offsetBy: section)
        let entries = tableData[idx].value
        
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let idx = tableData.index(tableData.startIndex, offsetBy: section)
        return tableData[idx].key
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCell
        
        let idx = tableData.index(tableData.startIndex, offsetBy: indexPath.section)
        let entries = tableData[idx].value

        cell.timeEntry = entries[indexPath.row]
        
        return cell
        
    }
    
    
}
