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

extension NSObject {

    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.nameOfClass, for: indexPath) as! TableViewCell
        let model = models[indexPath.row]
        cell.titleLabel.text = model.name
        cell.descriptionLabel.text = model.descript
        let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
        cell.accessoryView = checkmarkView
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let deletedItem = models.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableViewHeight.deactivate()
            tableView.snp.makeConstraints{ make in
                tableViewHeight = make.height.equalTo(models.count * 55).constraint
            }
            view.updateConstraints()
            
            // Remove the item from the context
            context.delete(deletedItem)
            
            // Save the changes
            do {
                try context.save()
            } catch {
                print("Error deleting item: \(error.localizedDescription)")
            }
            
            if models.count == 0{
                tableView.isHidden = true
            }
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let nameTextField = UITextField()
    let descriptionTextField = UITextField()
    let popupView = UIView()
    let label = UILabel()
    let addButton = UIButton()
    let editButton = UIButton()
    
    var tableViewHeight : Constraint!

    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.nameOfClass)
        table.translatesAutoresizingMaskIntoConstraints = false // Set this to false to enable auto layout
        return table
    }()
    
    let labelView = UIView()
    
    private var models = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        constraints()
    }

    func initialize(){
        view.backgroundColor = UIColor(ciColor: .white)
        
        label.text = "Создайте новую задачу нажав кнопку плюс."
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        view.addSubview(tableView)
        view.addSubview(label)
        
        labelView.backgroundColor = .black
        
        let pencilImage = UIImage(systemName: "pencil")?.resized(to: CGSize(width: 30, height: 30))
        editButton.setImage(pencilImage?.withTintColor(.white), for: .normal)

        editButton.contentMode = .scaleAspectFill
        editButton.backgroundColor = UIColor(red: 8/255, green: 106/255, blue: 199/255, alpha: 100)
        editButton.imageView?.tintColor = .white
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.layer.cornerRadius = 25
        editButton.clipsToBounds = true
        
        view.addSubview(editButton)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        
        
        let image = UIImage(systemName: "plus")?.resized(to: CGSize(width: 30, height: 30))
        addButton.setImage(image?.withTintColor(.white), for: .normal)

        addButton.contentMode = .scaleAspectFill
        addButton.backgroundColor = UIColor(red: 47/255, green: 151/255, blue: 76/255, alpha: 100)
        addButton.imageView?.tintColor = .white
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 25
        addButton.clipsToBounds = true
        
        
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        
       
        getAllTimes()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.rowHeight = 50
    
        if ((models.count) != 0){
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
    
    @objc func addButtonTapped() {
            showPopup()
        }
    
    @objc func editButtonTapped(){
        editButton.isSelected = !editButton.isSelected
        
        let pencilImage = editButton.isSelected ? UIImage(systemName: "xmark")?.resized(to: CGSize(width: 30, height: 30)) : UIImage(systemName: "pencil")?.resized(to: CGSize(width: 30, height: 30))
        editButton.setImage(pencilImage?.withTintColor(.white), for: .normal)
        
        tableView.setEditing(true, animated: true)
        editButton.isSelected ? (tableView.isEditing = true) : (tableView.isEditing = false)
        tableView.allowsSelectionDuringEditing = true
        
        if editButton.isSelected{
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
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
                self.popupView.transform = .identity
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
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Название"
        nameTextField.borderStyle = .roundedRect
        popupView.addSubview(nameTextField)
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Описание"
        descriptionTextField.contentVerticalAlignment = .top
        descriptionTextField.borderStyle = .roundedRect
        popupView.addSubview(descriptionTextField)
        
        popUpViewConstraints()
    }
    
    @objc func saveButtonTapped() {
        self.createItem(name: self.nameTextField.text ?? "Name", descript: self.descriptionTextField.text ?? "Description")
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.popupView.removeFromSuperview()
        }
        getAllTimes()
        tableViewHeight.deactivate()
        tableView.snp.makeConstraints{ make in
            tableViewHeight = make.height.equalTo(models.count * 55).constraint
        }
        view.updateConstraints()
    }
    
    @objc func cancelButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.popupView.removeFromSuperview()
        }
    }
    
    func getAllTimes() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // error
        }
    }
    
    func createItem(name: String, descript: String){
        let newItem = ToDoListItem(context: context)
        newItem.id = Int32()
        newItem.name = name
        newItem.descript = descript
        
        do {
            try context.save()
            getAllTimes()
        }
        catch {
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String, newDescr: String){
        item.name = newName
        item.descript = newDescr
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
            self.view.endEditing(true)
        }
        
    
    func constraints(){
        editButton.snp.makeConstraints{maker in
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(120)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints{maker in
            maker.right.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().inset(50)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        
        tableView.snp.updateConstraints() { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview().offset(models.count * (-150))
//            make.height.equalTo(models.count * 55)
        }
        
        tableView.snp.makeConstraints{ make in
            tableViewHeight = make.height.equalTo(models.count * 55).constraint
        }
        
        label.snp.updateConstraints() { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
//            make.trailing.equalTo(50)
//            make.leading.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func popUpViewConstraints(){
        nameTextField.snp.makeConstraints{ maker in
            maker.left.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(120)
            maker.right.equalToSuperview().inset(40)
            maker.height.equalTo(40)
        }
        
        descriptionTextField.snp.makeConstraints{ maker in
            maker.left.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(180)
            maker.right.equalToSuperview().inset(40)
            maker.bottom.equalToSuperview().inset(100)
        }
    }
}
