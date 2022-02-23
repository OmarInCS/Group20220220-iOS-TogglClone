//
//  BottomSheetVC.swift
//  TogglClone
//
//  Created by user on 2/23/22.
//

import UIKit

class BottomSheetVC: UIViewController {
    
    
    @IBOutlet weak var lbDuration: UILabel!
    
    @IBOutlet weak var tfDescription: UITextField!
    
    @IBOutlet weak var tfProject: UITextField!
    
    @IBOutlet weak var dpStartTime: UIDatePicker!
    
    @IBOutlet weak var dpEndTime: UIDatePicker!
    
    var pvProjects = UIPickerView()
    var selectedProject: Project!
    var updateParent: (() -> ())!
    var allProjects = TogglService.getAllProjects()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pvProjects.dataSource = self
        pvProjects.delegate = self
        tfProject.inputView = pvProjects
    }
    
    @IBAction func closeBottomSheet(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTimeEntry(_ sender: Any) {
        
        
        if tfDescription.text == nil || tfDescription.text == "" {
            print("discription is missing")
            return
        }
        
        let newEntry = TimeEntry(startTime: dpStartTime.date, description: tfDescription.text!, endTime: dpEndTime.date, project: selectedProject)
        TimeEntry.dummyEntries.append(newEntry)
        self.dismiss(animated: true, completion: nil)
        self.updateParent()
    }
    
    
    @IBAction func updateDuration(_ sender: Any) {
        
        let start = dpStartTime.date
        let end = dpEndTime.date
        let duration = start.distance(to: end)
        
        let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "en-US")
        formatter.allowedUnits = [.hour, .minute]
        
        lbDuration.text = formatter.string(from: duration)
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BottomSheetVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allProjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return allProjects[row].projectName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedProject = allProjects[row]
        tfProject.text = selectedProject.projectName
        tfProject.resignFirstResponder()
    }
    
}


