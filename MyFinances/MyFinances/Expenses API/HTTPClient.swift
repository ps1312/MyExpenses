//
//  HTTPClient.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}
