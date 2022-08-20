//
//  Attraction.swift
//  TravelDiscoveryLBTA
//
//  Created by Minate on 6/29/22.
//

import Foundation

struct Attraction : Identifiable {
    let id = UUID().uuidString
    
    let name, imageName: String
    let latitude, longitude: Double
}
