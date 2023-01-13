//
//  NewsTableViewCell.swift
//  News App
//
//  Created by BJIT  on 13/1/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemMint
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(authorLabel)
        contentView.addSubview(view)
        
        
        // TITLE LABEL CONSTRAINTS
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
            //label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        // CODE LABEL
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            //codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10)
        ])
        
        // Type label
        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor,constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
