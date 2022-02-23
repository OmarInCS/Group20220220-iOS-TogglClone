//
//  TimeEntry.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation

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

