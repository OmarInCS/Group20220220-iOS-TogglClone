//
//  TimeEntry.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation

class TimeEntry : Hashable, Equatable {
    var startTime: Date
    var description: String
    var endTime: Date?
    var project: Project?
    private var timer: Timer?
    
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
    
    static func groupEntriesByStartDate(_ entries: [TimeEntry]) -> [String: [TimeEntry]] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y MM d, E"
        formatter.locale = Locale(identifier: "en-US")
        
        return Dictionary(grouping: entries) { e in
            return formatter.string(from: e.startTime)
        }
        
    }
    

   
    static var dummyEntries = [
        TimeEntry(startTime: Date(), description: "Do Some Thing", endTime: Date(timeInterval: 60 * 60, since: Date()), project: Project.dummyProjects[0]),
        TimeEntry(startTime: Date(timeInterval: -150 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -147 * 60 * 60, since: Date()), project: Project.dummyProjects[0]),
        TimeEntry(startTime: Date(timeInterval: -150 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -145 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
        TimeEntry(startTime: Date(), description: "Do Some Thing", endTime: Date(timeInterval: 150 * 60, since: Date()), project: Project.dummyProjects[2]),
        TimeEntry(startTime: Date(timeInterval: -120 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -118 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
        TimeEntry(startTime: Date(timeInterval: -108 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -105 * 60 * 60, since: Date()), project: Project.dummyProjects[0]),
        TimeEntry(startTime: Date(timeInterval: -118 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -117 * 60 * 60, since: Date()), project: Project.dummyProjects[2]),
        TimeEntry(startTime: Date(timeInterval: -45 * 60 * 60, since: Date()), description: "Do Some Thing", endTime: Date(timeInterval: -43 * 60 * 60, since: Date()), project: Project.dummyProjects[1]),
        
    ]
   
    
    
   
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
    }
    
    public static func ==(lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

