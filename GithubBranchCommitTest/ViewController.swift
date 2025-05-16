//
//  ViewController.swift
//  GithubBranchCommitTest
//
//  Created by User on 16.05.25.
//

import UIKit

class ViewController: UIViewController {
    private let noteTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Yeni qeyd əlavə edin..."
          textField.textAlignment = .left
          textField.borderStyle = .roundedRect
          textField.font = UIFont.systemFont(ofSize: 16)
          textField.backgroundColor = .systemGray6
          textField.textColor = .black
          return textField
      }()
      
      private let saveButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Əlavə et", for: .normal)
          button.backgroundColor = .systemBlue
          button.setTitleColor(.white, for: .normal)
          button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
          button.layer.cornerRadius = 10
          return button
      }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          setupUI()
          
          saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
      }
      
      private func setupUI() {
          view.backgroundColor = .white
          title = "Qeyd əlavə et"
          view.addSubview(noteTextField)
          view.addSubview(saveButton)
          
          noteTextField.snp.makeConstraints { make in
              make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
              make.leading.equalToSuperview().offset(20)
              make.trailing.equalToSuperview().offset(-20)
              make.height.equalTo(50)
          }
          
          saveButton.snp.makeConstraints { make in
              make.top.equalTo(noteTextField.snp.bottom).offset(20)
              make.leading.equalToSuperview().offset(20)
              make.trailing.equalToSuperview().offset(-20)
              make.height.equalTo(50)
          }
      }
      
      @objc private func saveNote() {
          guard let noteText = noteTextField.text, !noteText.isEmpty else { return }
          let newNote = Note(text: noteText, date: Date())
          var notes = getNotes()
          notes.append(newNote)
         saveNotes(notes: notes)
          
          let vc = NotesViewController()
          navigationController?.pushViewController(vc, animated: true)
      }
      
      private func getNotes() -> [Note] {
          guard let data = UserDefaults.standard.data(forKey: "notes"),
                let notes = try? JSONDecoder().decode([Note].self, from: data) else {
              return []
          }
          return notes
      }
      
      private func saveNotes(notes: [Note]) {
          guard let data = try? JSONEncoder().encode(notes) else { return }
          UserDefaults.standard.set(data, forKey: "notes")
      }

}

