//
//  Note+CoreDataProperties.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Айдар Шарипов on 23/4/23.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var descript: String?

}

extension ToDoListItem : Identifiable {

}
