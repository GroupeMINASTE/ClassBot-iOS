//
//  DevoirsTableViewCell.swift
//  ClassBot
//
//  Created by Nathan FALLET on 05/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class DevoirsTableViewCell: UITableViewCell {

    let label = UILabel()
    let date = UILabel()
    let content = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(date)
        contentView.addSubview(content)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 17)
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        date.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
        date.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        date.adjustsFontSizeToFitWidth = true
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        content.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(devoirs: Devoirs) -> DevoirsTableViewCell {
        label.text = devoirs.name
        date.text = devoirs.due?.toDate()?.toRenderedString()
        content.text = devoirs.content
        
        return self
    }

}
