//
//  LimeAPIClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

let module = NSStringFromClass(LimeAPIClient.self).components(separatedBy:".")[0]

public typealias ApiResult<T: Decodable> = (Result<T, Error>) -> Void

public final class LimeAPIClient {
    let baseUrl: String
    let session: URLSession
    
    public init(baseUrl: String, session: URLSession = URLSession.shared) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    private func dataTask<T: Decodable>(with request: URLRequest, _ type: T.Type, completion: @escaping ApiResult<T>) {
        HTTPClient(self.session).getJSON(with: request) { (result) in
            switch result {
            case .success(let result):
                LimeAPIClient.log(request, message: result.statusCode)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let parser = JSONParser(decoder)
                let result = parser.decode(T.self, result.data)
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request<T: Decodable>(_ type: T.Type, endPoint: EndPoint, completion: @escaping ApiResult<T>) {
        let request: URLRequest
        do {
            let parameters = try LACParameters(baseUrl: self.baseUrl, endPoint: endPoint)
            request = parameters.request
        } catch {
            completion(.failure(error))
            return
        }
        
        self.dataTask(with: request, T.self) { (result) in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                LimeAPIClient.log(request, message: error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    public func requestChannels(completion: @escaping ApiResult<[Channel]>) {
        DispatchQueue(label: "tv.limehd.LimeAPIClient.requestChannels", qos: .userInitiated).async {
            self.request(JSONAPIObject<[Channel]>.self, endPoint: .channels) { (result) in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async { completion(.success(result.data)) }
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    public func requestBroadcasts(channelId: Int, dateInterval: LACDateInterval, completion: @escaping ApiResult<[Channel]>) {
        let timeZone = dateInterval.timeZone
        let endPoint = EndPoint.broadcasts(
            channelId: channelId,
            start: dateInterval.start.rfc3339String(for: timeZone),
            end: dateInterval.end.rfc3339String(for: timeZone),
            timeZone: timeZone.utcString)
        DispatchQueue(label: "tv.limehd.LimeAPIClient.requestBroadcasts", qos: .userInitiated).async {
            self.request(JSONAPIObject<[Channel]>.self, endPoint: endPoint) { (result) in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async { completion(.success(result.data)) }
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    public func ping(key: String = "", completion: @escaping ApiResult<Ping>) {
        DispatchQueue(label: "tv.limehd.LimeAPIClient.ping", qos: .userInitiated).async {
            self.request(Ping.self, endPoint: .ping(key: key)) { (result) in
                switch result {
                case .success(let result):
                    DispatchQueue.main.async { completion(.success(result)) }
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    private static func log(_ request: URLRequest, message: String) {
        let url = request.url?.absoluteString ?? "(пустое значение ulr)"
        print("\(module)\n\(url)\n\(message)")
    }
}
