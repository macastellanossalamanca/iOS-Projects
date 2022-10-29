//
//  OTPManager.swift
//  2FA iOS App
//
//  Created by Miguel Angel Castellanos Salamanca on 26/10/22.
//

import Foundation
import SwiftOTP
import UIKit

class OTPManager {
    var delegate: ManagerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addNewOTP(issuer: String, secrets: String) {
        if let data = base32DecodeToData(secrets), let totp = TOTP(secret: data), let code = totp.generate(time: Date(timeIntervalSinceNow: 0)) {
            let newOTP = OTP(context: context)
            newOTP.issuer = issuer
            newOTP.secrets = secrets
            newOTP.otpCode = code
            newOTP.time = 30
            print("Called Delegate")
            do {
                try context.save()
            } catch {}
            delegate?.didUpdate(model: newOTP)
        }
    }
    
    func generateNewCode(secrets: String) -> String? {
        var answer: String?
        if let data = base32DecodeToData(secrets), let totp = TOTP(secret: data), let code = totp.generate(time: Date(timeIntervalSinceNow: 0)) {
            answer = code
        }
        return answer
    }
}
protocol ManagerDelegate {
    func didUpdate(model: OTP)
}
