//
//  TogglService.swift
//  TogglClone
//
//  Created by user on 2/23/22.
//

import Foundation

class TogglService {
    
    private static let baseUrl = "https://toggl-clone-api.herokuapp.com"
    
    static func getAllProjects() -> [Project] {
        
        var projects = [Project]()
        
        let url = URL(string: baseUrl + "/projects")!
        
        let lock = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
            
                projects = try decoder.decode([Project].self, from: data!)
                
                lock.signal()
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        lock.wait()
        
        return projects
        
    }
    
    
    static func getAllEntries() -> [TimeEntry] {
        
        var entries = [TimeEntry]()
        
        let url = URL(string: baseUrl + "/entries")!
        
        let lock = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en-US")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            entries = try! decoder.decode([TimeEntry].self, from: data)
            lock.signal()
            
        }
        
        task.resume()
        
        lock.wait()
        
        return entries

        
    }
    
}
