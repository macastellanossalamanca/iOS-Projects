//
//  ViewController.swift
//  iOS Tech Practice
//
//  Created by Miguel Angel Castellanos Salamanca on 23/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var banks : Observable<[BankModel]> = Observable(value: [])
    var manager = ModelManager()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        manager.delegate = self
        
        banks.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if UserDefaults.standard.bool(forKey: "First Launch") == false {
            print("Primera vez")
            UserDefaults.standard.set(true, forKey: "First Launch")
        } else {
            print("No es la primera vez")
        }
        manager.fetch()
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = banks.value?[indexPath.row].bankName
        cell.detailTextLabel?.text = banks.value?[indexPath.row].description
        return cell
    }
}

extension ViewController: ManagerDelegate {
    func didUpdate(model: [BankModel]) {
        banks.value = model.compactMap ({
            BankModel(description: $0.description, age: $0.age, url: $0.url, bankName: $0.bankName)
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
