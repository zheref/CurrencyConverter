//
//  ConversionFetcher.swift
//  CurrencyConverter
//
//  Created by Sergio Daniel on 5/26/19.
//  Copyright © 2019 Sergio Daniel. All rights reserved.
//

import Foundation

typealias LatestRatesHandler = (LatestRatesResponse?, Error?) -> Void

protocol ConversionFetcherProtocol {
    
    func fetchLatestRates(completion: @escaping LatestRatesHandler) -> URLSessionDataTask?
    
}

class ConversionFetcher : ConversionFetcherProtocol {
    
    // MARK: - NESTED TYPES
    
    struct K {
        struct UrlString {
            static let base = "http://data.fixer.io/api"
        }
        
        struct Key {
            static let access = "f0b18df4f876016fe3aaecf789225f24"
        }
    }
    
    // MARK: - CLASS MEMBERS
    
    static let standard: ConversionFetcherProtocol = ConversionFetcher()
    
    // MARK: - INITIALIZERS
    
    private init() {}
    
    // MARK: - INSTANCE OPERATIONS
    
    // MARK: Exposed Operations
    
    func fetchLatestRates(completion: @escaping LatestRatesHandler) -> URLSessionDataTask? {
        let completeUrlString = "\(K.UrlString.base)/latest?access_key=\(K.Key.access)&base=\(Currency.USD.raw)&symbols=\(Currency.GBP.raw),\(Currency.EUR.raw),\(Currency.JPY.raw),\(Currency.BRL.raw)"
        
        guard let actualUrl = URL(string: completeUrlString) else {
            print("Could not parse into a valid URL: \(completeUrlString)")
            return nil
        }
        
        print("Fetching URL: \(completeUrlString)")
        let task = URLSession.shared.dataTask(with: actualUrl) { data, response, error in
            if let error = error {
                debugPrint(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    debugPrint(response ?? "Response has not been unwrapped sucessfully")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint(httpResponse)
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decoded = try decoder.decode(LatestRatesResponse.self, from: data)
                completion(decoded, error)
            } catch {
                debugPrint(error)
                completion(nil, error)
            }
        }
        
        task.resume()
        return task
    }
    
}
