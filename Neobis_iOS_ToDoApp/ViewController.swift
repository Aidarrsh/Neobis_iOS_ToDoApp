//
//  ViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Айдар Шарипов on 18/4/23.
//

import UIKit
import SnapKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

let popupView = UIView()


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }

    private func initialize(){
        view.backgroundColor = UIColor(ciColor: .white)
        
        let label = UILabel()
        label.text = "Создайте новую задачу нажав кнопку плюс."
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        view.addSubview(label)
        
        label.snp.makeConstraints{maker in
            maker.left.equalToSuperview().inset(50)
            maker.top.equalToSuperview().inset(100)
            maker.right.equalToSuperview().inset(50)

        }
        let editButton = UIButton()
        let pencilImage = UIImage(systemName: "pencil")?.resized(to: CGSize(width: 30, height: 30))
        editButton.setImage(pencilImage?.withTintColor(.white), for: .normal)

        editButton.contentMode = .scaleAspectFill
        editButton.backgroundColor = UIColor(red: 8/255, green: 106/255, blue: 199/255, alpha: 100)
        editButton.imageView?.tintColor = .white
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.layer.cornerRadius = 25
        editButton.clipsToBounds = true
        
        view.addSubview(editButton)
        
        editButton.snp.makeConstraints{maker in
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(120)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        
        let addButton = UIButton()
        let image = UIImage(systemName: "plus")?.resized(to: CGSize(width: 30, height: 30))
        addButton.setImage(image?.withTintColor(.white), for: .normal)

        addButton.contentMode = .scaleAspectFill
        addButton.backgroundColor = UIColor(red: 47/255, green: 151/255, blue: 76/255, alpha: 100)
        addButton.imageView?.tintColor = .white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 25
        addButton.clipsToBounds = true
        
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints{maker in
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(50)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        addButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
            showPopup()
        }
    
    @objc func showPopup() {
        popupView.backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 247/255, alpha: 100)
        view.addSubview(popupView)
            
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        popupView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        popupView.heightAnchor.constraint(equalToConstant: 300)
            
        popupView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            UIView.animate(withDuration: 0.3) {
                popupView.transform = .identity
        }
        
        let navigationView = UINavigationController()
        let customViewController = UIViewController() // Your custom view controller
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .red
        customViewController.navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .systemBlue
        customViewController.navigationItem.rightBarButtonItem = saveButton
        
        navigationView.viewControllers = [customViewController]
        navigationView.navigationBar.tintColor = .black
        navigationView.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        popupView.addSubview(navigationView.view)
        navigationView.view.translatesAutoresizingMaskIntoConstraints = false
        navigationView.view.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationView.view.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        navigationView.view.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        navigationView.view.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        
        let separatorView = UIView()
            separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            
            navigationView.view.addSubview(separatorView)
            separatorView.topAnchor.constraint(equalTo: navigationView.navigationBar.bottomAnchor).isActive = true
            separatorView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Название"
        nameTextField.borderStyle = .roundedRect
        popupView.addSubview(nameTextField)
        
        nameTextField.snp.makeConstraints{ maker in
            maker.left.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(120)
            maker.right.equalToSuperview().inset(40)
            maker.height.equalTo(40)
        }
        
        let descriptionTextField = UITextField()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Описание"
        descriptionTextField.contentVerticalAlignment = .top
        descriptionTextField.borderStyle = .roundedRect
        popupView.addSubview(descriptionTextField)
        
        descriptionTextField.snp.makeConstraints{ maker in
            maker.left.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(180)
            maker.right.equalToSuperview().inset(40)
            maker.bottom.equalToSuperview().inset(100)
        }
            
    }
    
    @objc func saveButtonTapped() {
        //TODO
    }
    
    @objc func cancelButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            popupView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            popupView.removeFromSuperview()
        }
    }
    
    
}
