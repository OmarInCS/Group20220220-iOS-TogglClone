//
//  TimeEntry.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation
import UIKit
import CoreData

class TimeEntry : Hashable, Equatable, Codable {
    var startTime: Date
    var description: String
    var endTime: Date?
    var project: Project?
    private var timer: Timer?
    
    enum CodingKeys: String, CodingKey {
        case startTime, description, endTime, project
    }
    
    
    var duration: TimeInterval {
        return startTime.distance(to: endTime ?? Date())
    }
    
    var entryCost: Double {
        return (project?.hourRate ?? 0) * duration / 60 / 60
    }
    
    init(startTime: Date = Date(), description: String = "No Description", endTime: Date? = nil, project: Project? = nil) {
        
        self.startTime = startTime
        self.description = description
        self.endTime = endTime
        self.project = project
        
    }
    
    required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.description = try container.decode(String.self, forKey: .description)
        self.endTime = try container.decode(Date.self, forKey: .endTime)
        self.project = try container.decode(Project.self, forKey: .project)
    }
    
    
    static func groupEntriesByStartDate(_ entries: [TimeEntry]) -> [String: [TimeEntry]] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y MM d, E"
        formatter.locale = Locale(identifier: "en-US")
        
        return Dictionary(grouping: entries) { e in
            return formatter.string(from: e.startTime)
        }
        
    }
    
    static func aggregateDayDuration(_ entries: [TimeEntry]) -> [String: Double]{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM d, E"
        formatter.locale = Locale(identifier: "en-US")
        
        return Dictionary(grouping: entries) { e in
            return formatter.string(from: e.startTime)
        }.mapValues { dayEntries in
            return dayEntries.reduce(0) { total, dayEntry in
                return total + dayEntry.duration
            }
        }
    }
    
    static func aggregateProjectDuration(_ entries: [TimeEntry]) -> [String: Double] {
        
        return Dictionary(grouping: entries) { e in
            return e.project?.projectName ?? "No Project"
        }.mapValues { dayEntries in
            return dayEntries.reduce(0) { total, dayEntry in
                return total + dayEntry.duration
            }
        }
    }
    
    func startTimer(handleTick: (()->())?) {
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            
            
            handleTick?()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        endTime = Date()
    }
    
    public func createTimeEntry() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let timeEntity = NSEntityDescription.entity(forEntityName: "TimeEntries", in: managedContext)!
        
        let timeEntry = NSManagedObject(entity: timeEntity, insertInto: managedContext)
        
        timeEntry.setValue(self.startTime, forKey: "start_time")
        timeEntry.setValue(self.description, forKey: "details")
        timeEntry.setValue(self.endTime, forKey: "end_time")
//        timeEntry.setValue(self.startTime, forKey: "start_time")
        if self.project != nil {
            let project = Project.getProjectByName(projectName: project!.projectName)
            timeEntry.setValue(project, forKey: "project")
        }
        
        try! managedContext.save()
    }
    
    public static func fetchAllTimeEntries() -> [TimeEntry] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var entries = [TimeEntry]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeEntries")
        
        let result = try! managedContext.fetch(request)
        
        for row in result as! [NSManagedObject] {
            
            
            let entry = TimeEntry(
                startTime: row.value(forKey: "start_time") as! Date,
                description: row.value(forKey: "details") as! String,
                endTime: row.value(forKey: "end_time") as? Date,
                project: nil
            )
            
            let project = row.value(forKey: "project")
            
            if project != nil {
                entry.project = Project(
                    projectName: row.value(forKeyPath: "project.project_name") as! String,
                    clientName: row.value(forKeyPath: "project.client_name") as? String,
                    hourRate: row.value(forKeyPath: "project.hour_rate") as! Double
                )
            }
            
            entries.append(entry)
        }
        
        return entries
    }
    

   
    static var dummyEntries: [TimeEntry] = [
//        TimeEntry(startTime: Date(), description: "Do Some Thing", endTime: Date(timeInterval: 60 * 60, since: Date()), project: Project.dummyProjects[0]),
//        TimeEntry(startTime: Date(timeInterval: -150 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -147 * 60 * 60, since: Date()), project: Project.dummyProjects[0]),
//        TimeEntry(startTime: Date(timeInterval: -150 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -145 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
//        TimeEntry(startTime: Date(), description: "Do Some Thing", endTime: Date(timeInterval: 150 * 60, since: Date()), project: Project.dummyProjects[2]),
//        TimeEntry(startTime: Date(timeInterval: -120 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -118 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
//        TimeEntry(startTime: Date(timeInterval: -108 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -105 * 60 * 60, since: Date()), project: Project.dummyProjects[0]),
//        TimeEntry(startTime: Date(timeInterval: -118 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -117 * 60 * 60, since: Date()), project: Project.dummyProjects[2]),
//        TimeEntry(startTime: Date(timeInterval: -45 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -43 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
//        
    ]
   
    
    
   
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
    }
    
    public static func ==(lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

