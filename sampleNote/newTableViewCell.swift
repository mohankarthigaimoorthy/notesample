//
//  newTableViewCell.swift
//  sampleNote
//
//  Created by Mohan K on 14/03/23.
//

import UIKit

class newTableViewCell: UITableViewCell {

    static let id = "newTableViewCell"
    private var sample: Sample?
    var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        textLabel?.font = .systemFont(ofSize: 24, weight:  .semibold)
        detailTextLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        setupDateLabel ()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    private func setupDateLabel () {
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 74, height: 50))
        dateLabel.textAlignment = .right
    accessoryView = dateLabel
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 14)
    }
    
    func configureLabels() {
        self.textLabel?.text = sample?.title ?? ""
        self.detailTextLabel?.text = sample?.text ?? ""
        
        guard let sample = sample else {
            print ("Found nil value in variable note")
    return}
        let formatter = DateFormatter()
        if Date.isToday(day: sample.date!.get(.day)) {
            formatter.dateFormat = "HH:mm"
        }
        else if Date.isThisYear(year: sample.date!.get(.year)) {
            formatter.dateFormat = "MMM d"
        }
        else {
            formatter.dateFormat = "MM/dd/yyyy"
        }
        dateLabel.text = formatter.string(from: sample.date!)
        
    }
    
    func configure(sample: Sample) {
        self.sample = sample
    }
    
    func prepareNote() {
        self.sample = nil
    }
}
