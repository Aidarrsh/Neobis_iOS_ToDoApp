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
    let checkButton = UIButton()
    let infoButton = UIButton()
    let arrowSymbol = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews to the cell's contentView
        
        arrowSymbol.text = ">"
        arrowSymbol.textColor = .gray
        
        let infoImage = UIImage(systemName: "info.circle")?.resized(to: CGSize(width: 25, height: 25))
//        infoButton.tintColor = .systemBlue
        infoButton.setImage(infoImage?.withTintColor(.systemBlue), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        
        let checkImage = UIImage(systemName: "circle")
        checkButton.tintColor = .systemOrange
        checkButton.setImage(checkImage, for: .normal)
        
        checkButton.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
        
        contentView.addSubview(arrowSymbol)
        contentView.addSubview(infoButton)
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        arrowSymbol.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(17)
            maker.right.equalToSuperview().inset(15)
        }
        infoButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(15)
            maker.right.equalToSuperview().inset(30)
        }
        
        checkButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(15)
            maker.left.equalToSuperview().inset(15)
        }
        
        // Set up constraints for the labels
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(4)
            maker.left.equalToSuperview().inset(45)
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
    
    @objc func checkButtonPressed(){
        checkButton.isSelected = !checkButton.isSelected
            let imageName = checkButton.isSelected ? "checkmark.circle" : "circle"
            let image = UIImage(systemName: imageName)
            checkButton.setImage(image, for: .normal)
    }
    
    @objc func infoButtonPressed(){
        let viewClass = ViewController()
        viewClass.showPopup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
