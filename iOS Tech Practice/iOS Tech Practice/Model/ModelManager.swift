//
//  ModelManager.swift
//  iOS Tech Practice
//
//  Created by Miguel Angel Castellanos Salamanca on 23/10/22.
//

import Foundation

struct ModelManager {
    
    let APIurl: String = "https://dev.obtenmas.com/catom/api/challenge/banks"
    
    var delegate: ManagerDelegate?
    
    func fetch() {
        performRequest(url: APIurl)
    }
    
    func performRequest(url: String) {
        print("performing")
        if let validUrl: URL = URL(string: url) {
            let session: URLSession = URLSession(configuration: .default)
            let task = session.dataTask(with: validUrl) {
                (data, response, error)  in
                if let safeData = data, let bankModel = parseJson(data: safeData) {
                    delegate?.didUpdate(model: bankModel)
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data: Data) -> [BankModel]? {
        print("parsing")
        let decoder = JSONDecoder()
        var bankModel: [BankModel]?
        do {
            bankModel = try decoder.decode([BankModel].self, from: data)
        } catch {
            print(error)
        }
        return bankModel
    }
}

protocol ManagerDelegate {
    func didUpdate(model: [BankModel])
}
