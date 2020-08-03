//
//  Person.swift
//  TestTask
//
//  Created by Nikolay Sohryakov on 03.08.2020.
//  Copyright © 2020 Storytelling Software. All rights reserved.
//

import Foundation

struct Person: Identifiable {
    let id: String
    
    var firstName: String?
    var lastName: String?
    var age: Int?
    var gender: String?
    var country: String?
}

extension Person: Codable {
    
}
