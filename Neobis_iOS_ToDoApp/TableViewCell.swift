//
//  TableViewCell.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Айдар Шарипов on 25/4/23.
//

import UIKit


class TableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews to the cell's contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        // Set up constraints for the labels
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(4)
            maker.left.equalToSuperview().inset(15)
            maker.right.equalToSuperview().inset(15)
        }
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(titleLabel.snp.right)
            maker.bottom.equalToSuperview().inset(4)
        }
        
        // Set up properties for the labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
