//
//  EntryCell.swift
//  TogglClone
//
//  Created by user on 2/21/22.
//

import UIKit

class EntryCell: UITableViewCell {
    
    
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet weak var lbStartTime: UILabel!
    
    @IBOutlet weak var lbEndTime: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    
    @IBOutlet weak var lbProjectName: UILabel!
    
    @IBOutlet weak var lbCost: UILabel!
    
    var timeEntry: TimeEntry! {
        didSet {
            lbDescription.text = timeEntry.description
            lbProjectName.text = timeEntry.project?.projectName
            lbCost.text = "SAR \(timeEntry.entryCost.rounded())"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en-US")
            lbStartTime.text = dateFormatter.string(from: timeEntry.startTime)
            lbEndTime.text = dateFormatter.string(from: timeEntry.endTime!)
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dataView.layer.cornerRadius = 16
        dataView.layer.shadowColor = UIColor.black.cgColor
        dataView.layer.shadowOpacity = 0.5
        dataView.layer.shadowRadius = 8
        dataView.layer.shadowOffset = .zero
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
