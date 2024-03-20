//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Okan Orkun on 16.03.2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private lazy var tableView = UITableView()
    private lazy var textField = UITextField()
    
    private lazy var viewModel = HomeViewModel()
    private lazy var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create text field
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add new todo"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(addButtonTapped), for: .editingDidEndOnExit)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Subscribe to changes in todo items
        viewModel.$toDos
            .sink(receiveValue: weakify({strongSelf, toDos in
                strongSelf.todoListDidUpdate(toDos)
            }))
            .store(in: &cancellables)
        
        // Set up table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    @objc private func addButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        viewModel.addToDo(text)
        textField.text = ""
    }
}

// MARK: Table View

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = viewModel.toDos[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleCompletion(for: viewModel.toDos[indexPath.row])
    }
}

// MARK: View Model Delegate

extension HomeViewController: HomeViewModelDelegate {
    func todoListDidUpdate(_ items: [ToDo]) {
        tableView.reloadData()
    }
}
