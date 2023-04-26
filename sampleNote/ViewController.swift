//
//  ViewController.swift
//  sampleNote
//
//  Created by Mohan K on 14/03/23.
//

import UIKit

class ViewController: UIViewController {

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }

    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
//    private func setupButton() {
//        view.addSubview(addButton)
//    }
//
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    internal func setupTableView() {
        let tableView = UITableView(frame: .zero)
        notesTable.register(newTableViewCell.self, forCellReuseIdentifier: newTableViewCell.id)
        notesTable.delegate = self
        notesTable.dataSource = self
        view.addSubview(notesTable)
        self.notesTable = tableView
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var addButton: UIButton!

//    var notesTable = UITableView?.self
    var searchedNotes = [Sample]()
    var searchController = UISearchController(searchResultsController: nil)
   static var sample = [Sample]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
      
//       
//        DispatchQueue.main.async {
//            self.notesTable.reloadData()
//        }
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @IBAction func createButton(_ sender: Any) {
   print("000")
        addButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

    }
    
    
    @objc private func didTapButton() {
        let newNote = CoreDataManager.shared.creatNote()
        ViewController.sample.insert(newNote, at: 0)
        notesTable!.beginUpdates()
        notesTable!.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        notesTable!.endUpdates()
        
        guard  let noteVC = storyboard?.instantiateViewController(identifier: "noteViewController")
                as? noteViewController else {return}
        noteVC.newTableViewcell = nil
        noteVC.set(noteId: newNote.id!)
        noteVC.set(newTableViewCell: (notesTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! newTableViewCell))
        navigationController?.pushViewController(noteVC, animated: true)
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        notesTable.contentInset = .zero
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            notesTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +  notesTable.rowHeight, right: 0)
        }
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            label.isHidden = true
            return searchedNotes.count
        }else {
            label.isHidden = false
            ViewController.sample.count == 0 ? label.animateIn() :
            label.animateOut()
            return ViewController.sample.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notesTable.dequeueReusableCell(withIdentifier: "newTableViewCell", for: indexPath) as? newTableViewCell else {
            return UITableViewCell()
        }
        
        if isSearching {
            cell.configure(sample: searchedNotes[indexPath.row])
        }
        else {
            cell.configure(sample: ViewController.sample[indexPath.row])
        }
        cell.configureLabels()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = noteViewController()
        if isSearching{
            noteVC.set(noteId: searchedNotes[indexPath.row].id!)
        }
        else {
            noteVC.set(noteId: ViewController.sample[indexPath.row].id!)
        }
        guard let cell = notesTable.cellForRow(at: indexPath) as? newTableViewCell
        else { return }
        noteVC.set(newTableViewCell: cell)
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeNote(row: indexPath.row, tableView: notesTable)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        }
        return true
    }
    
    internal func  removeNote(row: Int, tableView: UITableView) {
        ViewController.sample.remove(at: row)
        let path = IndexPath(row: row, section: 0)
        notesTable.deleteRows(at: [path], with: .top)
    }
    
    internal func removeCellIfEmpty() {
        guard let newTableViewCell = ViewController.sample.first else {return}
        if newTableViewCell.title!.trimmingCharacters(in: .whitespaces).isEmpty &&
            newTableViewCell.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            removeNote(row: 0, tableView: notesTable!)
        }
    }
}

extension ViewController {
    func fetchNotesFromStorage() {
        ViewController.sample = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNotesFromStorage(at index: Int) {
        CoreDataManager.shared.deleteNote(ViewController.sample[index])
    }
    
    func searchNotesFromStorage(_ text:  String) {
        searchedNotes = CoreDataManager.shared.fetchNotes(filter: text)
        notesTable?.reloadData()
    }
}
