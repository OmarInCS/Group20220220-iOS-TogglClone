//
//  Project.swift
//  toggl-clone
//
//  Created by user on 2/6/22.
//

import Foundation


struct Project {
    var projectName: String
    var clientName: String?
    var hourRate: Double = 0

    static var dummyProjects = [
        Project(projectName: "Toggl Clone", hourRate: 100),
        Project(projectName: "Stock Market Analyzer", hourRate: 150),
        Project(projectName: "Scratch Clone", hourRate: 150),
    ]

}
