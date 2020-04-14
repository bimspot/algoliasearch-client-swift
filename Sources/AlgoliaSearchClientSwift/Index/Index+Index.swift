//
//  Index+Index.swift
//  
//
//  Created by Vladislav Fitc on 01/04/2020.
//

import Foundation

extension Index {
  
  //MARK: - Delete index
  
  /**
   Delete the index and all its settings, including links to its replicas.
   - Parameter requestOptions: Configure request locally with RequestOptions.
   - Returns: Launched asynchronous operation
   */
  @discardableResult func delete(requestOptions: RequestOptions? = nil, completion: @escaping ResultCallback<DeletionIndex>) -> Operation & TransportTask {
    let command = Command.Index.DeleteIndex(indexName: name, requestOptions: requestOptions)
    return perform(command, completion: completion)
  }

  /**
   Delete the index and all its settings, including links to its replicas.
   - Parameter requestOptions: Configure request locally with RequestOptions.
   - Returns: DeletionIndex object
   */
  @discardableResult func delete(requestOptions: RequestOptions? = nil) throws -> DeletionIndex {
    let command = Command.Index.DeleteIndex(indexName: name, requestOptions: requestOptions)
    return try perform(command)
  }
  
  //MARK: - Exists
  
  /**
   Return whether an index exists or not
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func exists(completion: @escaping ResultCallback<Bool>) -> Operation & TransportTask {
    let command = Command.Settings.GetSettings(indexName: name, requestOptions: nil)
    return perform(command) { (result: Result<Settings, Swift.Error>) in
      switch result {
      case .success:
        completion(.success(true))
      case .failure(let error) where (error as? HTTPError)?.statusCode == .notFound:
        completion(.success(false))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /**
   Return whether an index exists or not
   - Returns: Bool
   */
  @discardableResult func exists() throws -> Bool {
    let command = Command.Settings.GetSettings(indexName: name, requestOptions: nil)
    let result = Result { try perform(command) as Settings }
    switch result {
    case .success:
      return true
    case .failure(let error) where (error as? HTTPError)?.statusCode == .notFound:
      return false
    case .failure(let error):
      throw error
    }
  }
  
  //MARK: - Copy index
  
  /**
   Make a copy of an index, including its objects, settings, synonyms, and query rules.
   
   - Note: This method enables you to copy the entire index (objects, settings, synonyms, and rules) OR one or more of the following index elements:
   - setting
   - synonyms
   - and rules (query rules)
   
   - Parameter destination: IndexName of the destination Index.
   - Parameter scopes: List of Scope. If omitted, then all objects and all Scope are copied.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func copy(_ scopes: [Scope]? = nil, to destination: IndexName, requestOptions: RequestOptions? = nil, completion: @escaping ResultCallback<RevisionIndex>) -> Operation & TransportTask {
    let command = Command.Index.Operation(indexName: name, operation: .init(action: .copy, destination: destination, scopes: scopes), requestOptions: requestOptions)
    return perform(command, completion: completion)
  }
  
  /**
   Make a copy of an index, including its objects, settings, synonyms, and query rules.
   
   - Note: This method enables you to copy the entire index (objects, settings, synonyms, and rules) OR one or more of the following index elements:
   - setting
   - synonyms
   - and rules (query rules)
   
   - Parameter destination: IndexName of the destination Index.
   - Parameter scopes: List of Scope. If omitted, then all objects and all Scope are copied.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: RevisionIndex  object
   */
  @discardableResult func copy(_ scopes: [Scope], to destination: IndexName, requestOptions: RequestOptions? = nil) throws -> RevisionIndex {
    let command = Command.Index.Operation(indexName: name, operation: .init(action: .copy, destination: destination, scopes: scopes), requestOptions: requestOptions)
    return try perform(command)
  }
  
  //MARK: - Move index
  
  /**
   Rename an index. Normally used to reindex your data atomically, without any down time.
   The move index method is a safe and atomic way to rename an index.
   - Parameter destination: IndexName of the destination Index.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func move(to destination: IndexName, requestOptions: RequestOptions? = nil, completion: @escaping ResultCallback<RevisionIndex>) -> Operation & TransportTask {
    let command = Command.Index.Operation(indexName: name, operation: .init(action: .move, destination: destination, scopes: nil), requestOptions: requestOptions)
    return perform(command, completion: completion)
  }
  
  /**
   Rename an index. Normally used to reindex your data atomically, without any down time.
   The move index method is a safe and atomic way to rename an index.
   - Parameter destination: IndexName of the destination Index.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: RevisionIndex  object
   */
  @discardableResult func move(to destination: IndexName, requestOptions: RequestOptions? = nil) throws -> RevisionIndex {
    let command = Command.Index.Operation(indexName: name, operation: .init(action: .move, destination: destination, scopes: nil), requestOptions: requestOptions)
    return try perform(command)
  }
  
}