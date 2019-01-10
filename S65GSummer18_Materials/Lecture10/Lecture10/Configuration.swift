//
//  Configuration.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import Foundation

struct Configuration : Encodable, Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "title"
        case contents = "contents"
    }
    let title : String?
    let contents: [[Int]]?
}
