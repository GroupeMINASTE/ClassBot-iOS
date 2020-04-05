//
//  CoursTableViewCell.swift
//  ClassBot
//
//  Created by Nathan FALLET on 05/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CoursTableViewCell: UITableViewCell {

    let label = UILabel()
    let date = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(date)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        date.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
        date.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        date.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        date.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(cours: Cours) -> CoursTableViewCell {
        label.text = cours.name
        date.text = cours.start?.toDate()?.toRenderedString()
        
        return self
    }

}
