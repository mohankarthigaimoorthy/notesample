//
//  noteViewController.swift
//  sampleNote
//
//  Created by Mohan K on 14/03/23.
//

import UIKit

class noteViewController: UIViewController, UITextFieldDelegate {

    private var noteId: String!
    private var index: Int!
     var newTableViewcell : newTableViewCell?
     var placeholderLabel: UILabel!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        index = ViewController.sample.firstIndex(where: {
            $0.id == noteId
        })
        view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
        self.contentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender: )))
        setupNavigationBarItem()
        placeholderLabel = UILabel()
        placeholderLabel.text = "Note"
        placeholderLabel.font = .italicSystemFont(ofSize: (contentTextView.font?.pointSize)!)
        contentTextView.addSubview( placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5,y: (contentTextView.font?.pointSize)!/2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
    }
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let note = ViewController.sample[index]
        titleTextField.text = note.title
        contentTextView.text = note.text
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      let newTableViewCell = newTableViewCell() 
        newTableViewCell.prepareNote()
        newTableViewCell.configure(sample : ViewController.sample[index])
        newTableViewCell.configureLabels()
    }
    
    private func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    func set(noteId: String) {
        self.noteId = noteId
    }
    
    func set(newTableViewCell: newTableViewCell) {
        self.newTableViewcell = newTableViewCell
    }
}

extension noteViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)

    }
}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension noteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !contentTextView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !contentTextView.text.isEmpty
    }
}
