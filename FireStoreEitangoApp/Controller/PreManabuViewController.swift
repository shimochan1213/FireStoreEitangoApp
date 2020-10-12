//
//  PreManabuViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/12.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit

class PreManabuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let ranges: [String] = ["1-20","21-40","41-60","61-80","81-100","81-100","81-100","81-100","81-100","81-100","81-100"]


    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
       
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranges.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = ranges[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 40)
        
        
      
        
        return cell
      }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height/7
    }
    
 
    
    
    
    
    
    
}
