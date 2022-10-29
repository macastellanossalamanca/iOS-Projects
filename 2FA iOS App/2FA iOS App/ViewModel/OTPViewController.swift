//
//  OTPViewController.swift
//  2FA iOS App
//
//  Created by Miguel Angel Castellanos Salamanca on 26/10/22.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var issuerTextField: UITextField!
    @IBOutlet weak var secretsTextField: UITextField!
    
    var manager = OTPManager()
    var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        manager.delegate = self
    }
    
}

//MARK: - OTP Manager Delegate Extension
extension OTPViewController: ManagerDelegate {
    func didUpdate(model: OTP) {
        print("DidUpdate")
        delegate?.handleOTPInfo(OTPModel: model)
    }
}


//MARK: - Register New OTP
extension OTPViewController {
    @IBAction func addNewOTP() {
        if let issuer = issuerTextField.text, let secret = secretsTextField.text{
            manager.addNewOTP(issuer: issuer, secrets: secret )
            dismiss(animated: true)
        }
    }
}

protocol ViewControllerDelegate {
    func handleOTPInfo(OTPModel: OTP)
}

