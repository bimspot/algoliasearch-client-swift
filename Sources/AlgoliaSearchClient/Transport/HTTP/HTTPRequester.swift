//
//  HTTPRequester.swift
//  
//
//  Created by Vladislav Fitc on 19/03/2020.
//

import Foundation

public protocol HTTPRequester {

  func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> TransportTask

}
