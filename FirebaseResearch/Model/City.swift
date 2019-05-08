//
//  City.swift
//  FirebaseResearch
//
//  Created by Khuc Dinh Minh Nguyen on 4/25/19.
//  Copyright © 2019 Khuc Dinh Minh Nguyen. All rights reserved.
//

import Foundation

struct City {
    var id: String
    var name: String
    var image: String
    var population: Int
    var isVisited: Bool
    
    var dictionary: [String : Any] {
        return [
            "id": id,
            "name": name,
            "images": image,
            "population": population,
            "visited": isVisited
        ]
    }
}

extension City {
    init?(dictionary: [String: Any], id: String) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let image = dictionary["images"] as? String,
            let population = dictionary["population"] as? Int,
            let isVisited = dictionary["visited"] as? Bool else {
                return nil
        }
        
        self.init(id: id, name: name, image: image, population: population, isVisited: isVisited)
    }
}
