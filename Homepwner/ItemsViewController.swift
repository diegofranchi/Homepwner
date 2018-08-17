//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by CampusUser on 2/14/18.
//  Copyright © 2018 Diego Franchi. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    //MARK: -
    @IBOutlet var addButton : UIButton!
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
       
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem){
            let indexPath = IndexPath(row: index, section: 0)
            // Insert this new row into the table
            print("$\(newItem.valueInDollars)")
            print(newItem.name)
            print("index:     \(index)")
            print("indexPath: \(indexPath)")
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    //MARK: - Bronze Challenge: Sections
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "> 50"
//        case 1:
//            return "<= 50"
//        default:
//            return nil
//        }
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
//        switch section {
//        case 0:
//            return itemStore.allItems.filter{ $0.valueInDollars > 50 }
//        case 1:
//            return itemStore.allItems.filter{ $0.valueInDollars <= 50 }
//        default:
//            return 1
//        }
    }
    //MARK: - Gold Challenge: Customizing the Table
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section <= 1 {
//            return 65
//        } else {
//            return 44
//        }
//    }
    //MARK: -
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]

        cell.nameLabel?.text = item.name
        cell.serialLabel?.text = item.serialNumber
        cell.valueLabel?.text = "$\(item.valueInDollars)"
        // MARK: - Bronze Challenge: Cell Colors
        cell.valueLabel.textColor = item.valueInDollars <= 50 ? UIColor.green : UIColor.red
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return cell
    }
    //MARK: -
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]

            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            // MARK: - Bronze Challenge: Renaming the Delete Button
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                //Remove the item from the store
                self.itemStore.removeItem(item)
                //Remove the item's image from the image store
                self.imageStore.deleteImage(forKey: item.itemKey)
                //Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            ac.addAction(deleteAction)

            //Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt: IndexPath, to: IndexPath) {
        itemStore.moveItem(from: moveRowAt.row, to: to.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            } default:
                preconditionFailure("Unexpected segue identifier.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        //MARK: - Gold Challenge: Customizing the Table
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
