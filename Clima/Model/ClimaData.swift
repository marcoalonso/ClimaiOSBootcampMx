//
//  ClimaData.swift
//  Clima
//
//  Created by marco rodriguez on 22/10/22.
//

import Foundation
struct ClimaData: Decodable, Encodable {
    let name: String
    let weather: [Weather]
    let main: Main
    
}

struct Main : Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
    let id: Int
}
