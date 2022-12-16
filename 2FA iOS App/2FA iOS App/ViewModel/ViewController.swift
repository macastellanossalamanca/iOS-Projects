//
//  ViewController.swift
//  2FA iOS App
//
//  Created by Miguel Angel Castellanos Salamanca on 26/10/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var OTPs : Observable<[OTP]> = Observable(value: [])
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var timer = Timer()
    let manager = OTPManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Twilio"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemRed
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OTPCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        OTPs.bind { [weak self] _ in
            DispatchQueue.main.async {
                print("Data is binding")
                self?.tableView.reloadData()
            }
        }
        loadData()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Called preparing Segue")
        if(segue.identifier == "newOTPSegue"){
            let displayVC = segue.destination as! OTPViewController
            displayVC.delegate = self
        }
    }
//    Escalabilidad, inyeccion, patrones, arquitecturas, Algoritmos de manera estructurada, codigo limpio
    
    func loadData() {
        let request: NSFetchRequest<OTP> = OTP.fetchRequest()
        do {
            OTPs.value = try context.fetch(request)
        } catch {}
    }
}
//MARK: - Table Handling
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTPs.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! OTPCell
        if let code = OTPs.value[indexPath.row].otpCode, let issuer = OTPs.value[indexPath.row].issuer {
            let time = OTPs.value[indexPath.row].time
            cell.issuerLabel?.text = issuer
            cell.OTPLabel.text = code
            cell.progressBar.progress = Float(time)/Float(30)
        }
        return cell
    }
    
}

//MARK: - OTP Controller Delegate
extension ViewController: ViewControllerDelegate {
    func handleOTPInfo(OTPModel: OTP) {
        print("Añade nuevo OTP")
        OTPs.value.append(OTPModel)
        print(OTPs)
    }
}

//MARK: - Updating Time and OTP Codes

extension ViewController {
    @objc func updateTimer() {
        for code in OTPs.value {
            if code.time > 0 {
                code.time -= 1
            } else {
                guard let secret = code.secrets else { return }
                guard let newCode = manager.generateNewCode(secrets: secret) else { return }
                code.time = 30
                code.otpCode = newCode
            }
        }
        tableView.reloadData()
    }
}

