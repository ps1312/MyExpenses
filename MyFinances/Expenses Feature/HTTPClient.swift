//
//  HTTPClient.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void)
}
