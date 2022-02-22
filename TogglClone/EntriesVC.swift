//
//  EntriesVC.swift
//  TogglClone
//
//  Created by user on 2/21/22.
//

import UIKit

class EntriesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension EntriesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TimeEntry.dummyEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCell
        
        cell.timeEntry = TimeEntry.dummyEntries[indexPath.row]
        
        return cell
        
    }
    
    
}
