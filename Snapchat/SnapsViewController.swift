//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Christian Wasmer on 19/03/2017.
//  Copyright © 2017 Christian Wasmer. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var snaps : [Snap] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            
            let snap = Snap()
            snap.imageURL = (snapshot.value! as AnyObject)["imageURL"] as! String
            snap.from = (snapshot.value! as AnyObject)["from"] as! String
            snap.descrip = (snapshot.value! as AnyObject)["description"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value! as AnyObject)["uuid"] as! String


            
            self.snaps.append(snap)
            
            self.tableView.reloadData()
        })

        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()

            
        })

        

        // Do any additional setup after loading the view.
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps 😔"
        } else {
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewsnapsegue", sender: snap)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewsnapsegue" {
        let nextVC = segue.destination as! ViewSnapViewController
        nextVC.snap = sender as! Snap
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
