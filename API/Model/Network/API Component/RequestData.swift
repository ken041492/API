//
//  RequestData.swift
//  API
//
//  Created by imac-1682 on 2023/8/15.
//

import Foundation

public func requestData<E, D>(method: NetworkRequest, path: ApiPathConstants, parameter: E?) async throws -> D where E: Encodable, D: Decodable {
    
    let urlRequest = handleHTTPMethod(method, path, parameter)
    do {
//        print("Before getting data")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
//        print("After getting data")

        guard let response = (response as? HTTPURLResponse) else {
            throw NetworkError.invalidResponse
        }
        let statusCode = response.statusCode
        print("catch StatusCode \(statusCode)")
        
        guard (200 ... 299).contains(statusCode) else {
            switch statusCode {
            case 400:
                throw NetworkError.invalidRequest
            case 401:
                throw NetworkError.authorizationError
            case 404:
                throw NetworkError.notFound
            case 500:
                throw NetworkError.internalError
            case 501:
                throw NetworkError.internalError
            case 502:
                throw NetworkError.serverError
            case 503:
                throw NetworkError.serverUnavailable
            default:
                throw NetworkError.invalidResponse
            }
        }
        
        do {
            let result = try JSONDecoder().decode(D.self, from: data)
            
            #if DEBUG
            print(printNetworkProgress(urlRequest: urlRequest, parameters: parameter, result: result))
            #endif
            
            return result
        } catch {
            throw NetworkError.jsonDecodeFalid(error as! DecodingError)
        }
    } catch {
        print(error.localizedDescription.indices)
        print("=================================")
        throw NetworkError.unknowError(error)
    }
}

private func handleHTTPMethod<E: Encodable>(_ method: NetworkRequest, _ path: ApiPathConstants, _ parameter: E?) -> URLRequest {
    
    let baseURL = Networkbase.https + Networkbase.appServer + path.rawValue
    let url = URL(string: baseURL)
    var urlRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    let httpType = ContentType.json.rawValue
    urlRequest.allHTTPHeaderFields = [NetworkHeader.contentType.rawValue : httpType]
    urlRequest.httpMethod = method.rawValue
    
    let dict1 = try? parameter.asDictionary()
    
    switch method {
    case .get:
        let parameters = dict1! as? [String : String]
        urlRequest.url = requestWithURL(urlString: urlRequest.url?.absoluteString ?? "", parameters: parameters ?? [:])
    default:
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict1 ?? [:], options: .prettyPrinted)
    }
    return urlRequest
}

private func requestWithURL(urlString: String, parameters: [String : String]?) -> URL? {
    
    guard var urlComponents = URLComponents(string: urlString) else { return nil }
    urlComponents.queryItems = []
    parameters?.forEach({(key, value) in
        urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
    })
    return urlComponents.url
}

private func printNetworkProgress<E, D>(urlRequest: URLRequest, parameters: E, result: D) where E: Encodable, D: Decodable {
    #if DEBUG
    print("=========================================")
    print("- URL: \(urlRequest.url?.absoluteString ?? "")")
    print("- Header: \(urlRequest.allHTTPHeaderFields ?? [:])")
    print("---------------Request-------------------")
    print(parameters)
    print("---------------Response------------------")
    print(result)
    print("=========================================")
    #endif
}
extension Encodable {
    
    func asDictionary() throws -> [String : Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
