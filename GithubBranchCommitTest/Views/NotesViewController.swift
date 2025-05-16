//
//  NotesViewController.swift
//  GithubBranchCommitTest
//
//  Created by User on 16.05.25.
//

import UIKit

class NotesViewController: UIViewController {
  
    private let tableView = UITableView()
    private var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNotes()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Qeydlərim"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: "notes"),
              let savedNotes = try? JSONDecoder().decode([Note].self, from: data) else {
            notes = []
            return
        }
        notes = savedNotes
        tableView.reloadData()
    }
    
    private func saveNotes() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        UserDefaults.standard.set(data, forKey: "notes")
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            return UITableViewCell()
        }
        
        let note = notes[indexPath.row]
        cell.configure(note: note.text, date: note.date)
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.notes.remove(at: indexPath.row)
            self.saveNotes()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
