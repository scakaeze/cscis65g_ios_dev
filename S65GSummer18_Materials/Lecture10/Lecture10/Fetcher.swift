//
//  Fetcher.swift
//  Lecture08
//
//  Created by Van Simmons on 7/25/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import Foundation

let ConfigurationURL = "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1"

class Fetcher: NSObject, URLSessionDelegate {
    
    var handler: FetchCompletionHandler?
    func session() -> URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
        NSLog("\(#function): Session received authentication challenge")
        completionHandler(.performDefaultHandling,nil)
    }
}

enum EitherOr {
    case success(Data)
    case failure(String)
}

extension Fetcher {
    typealias FetchCompletionHandler = (EitherOr) -> Void
    func fetch(url: URL, completionHandler completion: @escaping FetchCompletionHandler) {
        let task = session().dataTask(with: url) { (data: Data?, response: URLResponse?, netError: Error?) in
            guard let response = response as? HTTPURLResponse, netError == nil else {
                return completion(.failure(netError!.localizedDescription))
            }
            guard response.statusCode == 200 else {
                return completion(.failure("\(response.description)"))
            }
            guard let data = data  else {
                return completion(.failure("valid response but no data"))
            }
            completion(.success(data))
        }
        task.resume()
    }
}
