//
//  NotesTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/13/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell, UITextViewDelegate, EventEditorCellProtocol {
	func reloadInformations() {
		eventInformations = EventManagement.shared.eventInformation
		switch eventInformations.state {
		case .create:
			self.textView.isUserInteractionEnabled = false
		case .showDetail:
			self.textView.isUserInteractionEnabled = true
		}
	}
	
	
	var eventInformations: EventEditorEventInformations!
	
	
	let placeholderText: String = "Your Notes..."
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var shadowView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		textView.delegate = self
		
		self.eventInformations = EventManagement.shared.eventInformation
		self.backgroundColor = UIColor.clear
		
		self.labelView.backgroundColor = Color.lightBlue
		self.mainView.backgroundColor = Color.blue
		
		self.topView.layer.cornerRadius = self.labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
		
		self.textView.textColor = Color.white.withAlphaComponent(0.7)
		self.textView.text = eventInformations.notes ?? placeholderText
		self.label.textColor = Color.white
		self.shadowView.backgroundColor = UIColor.clear
		
        reloadInformations()
        
		if eventInformations.state == .showDetail {
			self.textView.isUserInteractionEnabled = false
		}
		
    }
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if (textView.text == placeholderText) {
			textView.text = ""
			textView.textColor = Color.white
		}
		textView.becomeFirstResponder()
		guard let superView = eventInformations.eventEditorTableViewController else { return }
		superView.enlarge(true)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if (textView.text == "") {
			textView.text = placeholderText
			textView.textColor = Color.white.withAlphaComponent(0.7)
			eventInformations.notes = nil
		} else {
			eventInformations.notes = textView.text
		}
		guard let superView = eventInformations.eventEditorTableViewController else { return }
		superView.enlarge(false)
	}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadInformations()
    }
	
    override func prepareForReuse() {
        reloadInformations()
    }
}
