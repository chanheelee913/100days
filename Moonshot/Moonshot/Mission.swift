//
//  Mission.swift
//  Moonshot
//
//  Created by 이찬희 on 3/3/24.
//

import Foundation


struct Mission: Codable, Identifiable {
    //nested struct
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo\(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time:.omitted) ?? "N/A"
    }
}
