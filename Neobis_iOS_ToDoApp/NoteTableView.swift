import UIKit

class NoteTableView: UITableViewController{
    var noteList = [Note]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "nameCellID") as! NoteCell
        
        let thisNote : Note!
        thisNote = noteList[indexPath.row]
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descLabel.text = thisNote.desc
        
        return noteCell
    }
}
