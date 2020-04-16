//
//  Command+Search.swift
//  
//
//  Created by Vladislav Fitc on 10.03.2020.
//

import Foundation

extension Command {

  enum Search {

    struct Search: AlgoliaCommand {

      let callType: CallType = .read
      let urlRequest: URLRequest
      let requestOptions: RequestOptions?

      init(indexName: IndexName,
           query: Query,
           requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions
        let path = .indexesV1 >>> .index(indexName) >>> IndexCompletion.query
        urlRequest = .init(method: .post,
                           path: path,
                           body: query.httpBody,
                           requestOptions: requestOptions)
      }

    }

    struct Browse: AlgoliaCommand {

      let callType: CallType = .read
      let urlRequest: URLRequest
      let requestOptions: RequestOptions?

      init(indexName: IndexName, query: Query, requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions
        let path = .indexesV1 >>> .index(indexName) >>> IndexCompletion.browse
        urlRequest = .init(method: .post, path: path, body: query.httpBody, requestOptions: requestOptions)
      }

      init(indexName: IndexName, cursor: Cursor, requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions.updateOrCreate([.cursor: cursor.rawValue])
        let path = .indexesV1 >>> .index(indexName) >>> IndexCompletion.browse
        urlRequest = .init(method: .get, path: path, requestOptions: requestOptions)
      }

    }

    struct SearchForFacets: AlgoliaCommand {

      let callType: CallType = .read
      let urlRequest: URLRequest
      let requestOptions: RequestOptions?

      init(indexName: IndexName, attribute: Attribute, facetQuery: String, query: Query?, requestOptions: RequestOptions?) {
        self.requestOptions = requestOptions
        let facetQueryParameters: [String: JSON] = ["facetQuery": .init(facetQuery)]
        let parameters = (query?.customParameters ?? [:]).merging(facetQueryParameters) { (_, new) in new }
        let body: Data
        if var query = query {
          query.customParameters = parameters
          body = ParamsWrapper(query).httpBody
        } else {
          body = ParamsWrapper(parameters).httpBody
        }
        let path = .indexesV1 >>> .index(indexName) >>> IndexCompletion.searchFacets(for: attribute)
        urlRequest = .init(method: .post, path: path, body: body, requestOptions: requestOptions)
      }

    }

  }

}
