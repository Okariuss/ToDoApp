//
//  ToDo.swift
//  ToDoApp
//
//  Created by Okan Orkun on 16.03.2024.
//

import Foundation

struct ToDo: Codable {
    let id: UUID
    var title: String
    var completed: Bool
}
