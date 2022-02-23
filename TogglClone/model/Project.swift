//
//  Project.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation


struct Project: Codable {
    var projectName: String
    var clientName: String?
    var hourRate: Double = 0

    static var dummyProjects: [Project] = [
        Project(projectName: "xxxToggl Clone", hourRate: 100),
        Project(projectName: "xxxStock Market Analyzer", hourRate: 150),
        Project(projectName: "xxxScratch Clone", hourRate: 150),
    ]

    
    
}
