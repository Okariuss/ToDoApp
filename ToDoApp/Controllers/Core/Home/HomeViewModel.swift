//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Okan Orkun on 16.03.2024.
//

import Foundation
import Combine

protocol HomeViewModelDelegate: AnyObject {
    func todoListDidUpdate(_ items: [ToDo])
}

protocol HomeViewModelProtocol {
    var toDos: [ToDo] { get }
    
    func addToDo(_ title: String)
    func toggleCompletion(for item: ToDo)
}

final class HomeViewModel: HomeViewModelProtocol {
    @Published var toDos: [ToDo] = []
    weak var delegate: HomeViewModelDelegate?
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "ToDos") {
            if let savedItems = try? JSONDecoder().decode([ToDo].self, from: data) {
                toDos = savedItems
            }
        }
    }
    
    func addToDo(_ title: String) {
        let newItem = ToDo(id: UUID(), title: title, completed: false)
        toDos.append(newItem)
        saveToDos()
        delegate?.todoListDidUpdate(toDos)
    }
        
    func toggleCompletion(for item: ToDo) {
        if let index = toDos.firstIndex(where: { $0.id == item.id }) {
            toDos[index].completed.toggle()
            saveToDos()
            delegate?.todoListDidUpdate(toDos)
        }
    }
    
    private func saveToDos() {
        if let encoded = try? JSONEncoder().encode(toDos) {
            UserDefaults.standard.set(encoded, forKey: "ToDos")
        }
    }
    
}
