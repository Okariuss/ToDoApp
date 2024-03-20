//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Okan Orkun on 16.03.2024.
//

import XCTest
@testable import ToDoApp

final class ToDoAppTests: XCTestCase {
    
    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddToDo() {
        let initialCount = viewModel.toDos.count
        
        viewModel.addToDo("New ToDo")
        
        XCTAssertEqual(viewModel.toDos.count, initialCount + 1)
        XCTAssertEqual(viewModel.toDos.last?.title, "New ToDo")
        XCTAssertFalse(viewModel.toDos.last?.completed ?? true)
    }
    
    func testToggleCompletion() {
        let toDo = ToDo(id: UUID(), title: "New ToDo", completed: false)
        viewModel.toDos = [toDo]
        
        viewModel.toggleCompletion(for: toDo)
        XCTAssertTrue(viewModel.toDos.first?.completed ?? false)
        
        viewModel.toggleCompletion(for: toDo)
        XCTAssertFalse(viewModel.toDos.first?.completed ?? true)
    }
}
