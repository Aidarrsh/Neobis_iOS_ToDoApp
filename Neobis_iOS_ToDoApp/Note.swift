//
//  Note.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Айдар Шарипов on 23/4/23.
//

import CoreData

@objc(Note)
class Note: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var descript: String!
    @NSManaged var deletedDate: Date!

}
