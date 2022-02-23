//
//  EntriesVC.swift
//  TogglClone
//
//  Created by user on 2/21/22.
//

import UIKit

class EntriesVC: UIViewController {
    
    @IBOutlet weak var tbEntries: UITableView!
    
    @IBOutlet weak var startView: UIStackView!
    
    @IBOutlet weak var stopView: UIStackView!
    
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    
    @IBOutlet weak var lbProject: UILabel!
    
    var tableData = TimeEntry.groupEntriesByStartDate(TogglService.getAllEntries())
    
    var runningEntry: TimeEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stopView.isHidden = true
    }
    
    func refreshData() {
        
        self.tableData = TimeEntry.groupEntriesByStartDate(TogglService.getAllEntries())
        self.tbEntries.reloadData()
    }
    
    
    @IBAction func handleStartTimer(_ sender: Any) {
        
        startView.isHidden = true
        stopView.isHidden = false
        
        runningEntry = TimeEntry()
        runningEntry?.startTimer(handleTick: {
            let formatter = DateComponentsFormatter()
            formatter.calendar?.locale = Locale(identifier: "en-US")
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad
            
            self.lbTime.text = formatter.string(from: self.runningEntry!.duration)
        })
        
    }
    
    
    @IBAction func handleStopTimer(_ sender: Any) {
        
        startView.isHidden = false
        stopView.isHidden = true
        
        runningEntry?.stopTimer()
        TimeEntry.dummyEntries.append(runningEntry!)
        runningEntry = nil
        lbTime.text = "00:00"
        refreshData()
        
    }
    
    

    
    @IBAction func showBottomSheet(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "bottomSheet") as! BottomSheetVC
        
        vc.updateParent = refreshData
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = true
        
        nav.sheetPresentationController?.detents = [.medium()]
        
        self.present(nav, animated: true, completion: nil)
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
