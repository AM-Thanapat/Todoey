//
//  ListModel.swift
//  Todoey
//
//  Created by Thanapat Saisoontornwattana on 7/6/2561 BE.
//  Copyright © 2561 Thanapat Saisoontornwattana. All rights reserved.
//

import UIKit

class Todo : Encodable, Decodable{
    var title: String = ""
    var done: Bool = false
    init(todoTitle: String) {
        self.title = todoTitle
    }
}
