//
//  WeatherData.swift
//  Lecture08
//
//  Created by Van Simmons on 7/25/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//
let testString = """
{
    "coord": {
        "lon": -0.13,
        "lat": 51.51
    },
    "weather": [
    {
    "id": 300,
    "main": "Drizzle",
    "description": "light intensity drizzle",
    "icon": "09d"
    }
    ],
    "base": "stations",
    "main": {
        "temp": 280.32,
        "pressure": 1012,
        "humidity": 81,
        "temp_min": 279.15,
        "temp_max": 281.15
    },
    "visibility": 10000,
    "wind": {
        "speed": 4.1,
        "deg": 80
    },
    "clouds": {
        "all": 90
    },
    "dt": 1485789600,
    "sys": {
        "type": 1,
        "id": 5091,
        "message": 0.0103,
        "country": "GB",
        "sunrise": 1485762037,
        "sunset": 1485794875
    },
    "id": 2643743,
    "name": "London",
    "cod": 200
}
"""

let testData = testString.data(using: .utf8)

struct Configuration : Encodable, Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "title"
        case contents = "contents"
    }
    let title : String?
    let contents: [[Int]]?
}

struct WeatherData : Encodable, Decodable, CustomStringConvertible {
    private enum CodingKeys : String, CodingKey {
        case coord = "coord"
        case main = "main"
        case name = "name"
        case stationId = "id"
    }
    let coord : Coord?
    let main: Main?
    let name: String?
    let stationId: Int?
    
    var description: String{
        return "Station: \(name ?? ""):\(stationId ?? -1)\nPosition: \(coord?.description ?? "")\n Conditions: \n\(main?.description ?? "")"
    }
}

struct Coord : Encodable, Decodable, CustomStringConvertible {
    private enum CodingKeys : String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
    let lon : Double
    let lat : Double
    var description: String {
        return "(\(lat), \(lon))\n"
    }
}

struct Main : Encodable, Decodable, CustomStringConvertible  {
    private enum CodingKeys : String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case min = "temp_min"
        case max = "temp_max"
    }
    let temp : Double?
    let pressure: Double?
    let humidity: Double?
    let min: Double?
    let max: Double?
    
    var description: String {
        return "Temp: \(temp ?? -1.0)\n\tPressure: \(pressure ?? -1.0)\n\tHumidity: \(humidity ?? -1.0)\n\tMin: \(min ?? -1.0)\n\tMax: \(max ?? -1.0)\n"
    }
}
