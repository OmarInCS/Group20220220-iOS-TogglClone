//
//  Project.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation
import UIKit
import CoreData


struct Project: Codable {
    var projectName: String
    var clientName: String?
    var hourRate: Double = 0

    static var dummyProjects: [Project] = [
        Project(projectName: "xxxToggl Clone", hourRate: 100),
        Project(projectName: "xxxStock Market Analyzer", hourRate: 150),
        Project(projectName: "xxxScratch Clone", hourRate: 150),
    ]

    
    public static func createDummyProjects() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let projectEntity = NSEntityDescription.entity(forEntityName: "Projects", in: managedContext)!
        
        for dummy in dummyProjects {
            
            let project = NSManagedObject(entity: projectEntity, insertInto: managedContext)
            
            project.setValue(dummy.projectName, forKey: "project_name")
            project.setValue(dummy.clientName, forKey: "client_name")
            project.setValue(dummy.hourRate, forKey: "hour_rate")
            
        }
        
        try! managedContext.save()
    }
    
    public static func fetchAllProjects() -> [Project] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var projects = [Project]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
        
        let result = try! managedContext.fetch(request)
        
        for row in result as! [NSManagedObject] {
            
            let project = Project(
                projectName: row.value(forKey: "project_name") as! String,
                clientName: row.value(forKey: "client_name") as? String,
                hourRate: row.value(forKey: "hour_rate") as! Double)
            
            projects.append(project)
            
        }
        
        return projects
    }
    
    
}
