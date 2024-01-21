//
//  AlamofireService.swift
//  app-starter
//
//  Created by hocgin on 2024/1/18.
//

import Alamofire
import Foundation
import SmartCodable

public protocol ApiEnvironment {
    var url: String { get }
}

public class ApiContext {
    var environment: ApiEnvironment
    public init(environment: ApiEnvironment) {
        self.environment = environment
    }
}

public struct RequestOptions {
    var headers: HTTPHeaders?
    var body: Parameters? = nil
    var method: HTTPMethod?
    var encoding: ParameterEncoding?
}

public typealias Completion<T> = (_ data: T?, _ error: Error?, _ resp: AFDataResponse<Data?>) -> Void

// https://github.com/intsig171/SmartCodable
// https://github.com/tristanhimmelman/ObjectMapper
// https://danielsaidi.com/blog/2018/12/27/alamofire-objectmapper
// https://medium.com/@tomasparizek/alamofire-objectmapper-must-have-combo-for-any-ios-developer-d5c25623562
public class RequestService {
    public init(context: ApiContext) {
        self.context = context
    }

    public var context: ApiContext

    public func get(at route: String) -> DataRequest {
        let options = RequestOptions(method: .get, encoding: URLEncoding.default)
        return request(at: route, options)
    }

    public func post(at route: String, _ options: inout RequestOptions) -> DataRequest {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.post
        return request(at: route, options)
    }

    public func put(at route: String, _ options: inout RequestOptions) -> DataRequest {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.put
        return request(at: route, options)
    }

    public func request(at route: String, _ options: RequestOptions) -> DataRequest {
        let url = url(route)
        let method = options.method!
        let params = options.body ?? [:]
        let headers = options.headers ?? [:]
        let encoding = options.encoding!

        print("请求 \(method.rawValue) \(url)")
        return AF.request(url, method: method, parameters: params, encoding: encoding, headers: headers).validate()
    }

    public func useRequest<T: SmartCodable>(at route: String, _ options: RequestOptions,
                                            completion: @escaping Completion<T>)
    {
        request(at: route, options).response { resp in
            switch resp.result {
            case .failure(let error):
                completion(nil, error, resp)
            case .success(let data):
                completion(T.deserialize(data: data), nil, resp)
            }
        }
    }

    public func useRequest<T: SmartCodable>(at route: String, _ options: RequestOptions) async throws -> T {
        return try await withCheckedContinuation { continuation in
            useRequest(at: route, options) { (result: T?, error: Error?, _) in
                if error != nil {
                    continuation.resume(throwing: error as! Never)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }

    public func useGet<T: SmartCodable>(at route: String) async throws -> T {
        return try await withCheckedContinuation { continuation in
            useGet(at: route) { (result: T?, error: Error?, _) in
                if error != nil {
                    continuation.resume(throwing: error as! Never)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }

    public func useGet<T: SmartCodable>(at route: String, completion: @escaping Completion<T>) {
        let options = RequestOptions(method: .get, encoding: URLEncoding.default)
        useRequest(at: route, options, completion: completion)
    }

    public func usePost<T: SmartCodable>(at route: String, _ options: inout RequestOptions, completion: @escaping Completion<T>) {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.post
        useRequest(at: route, options, completion: completion)
    }

    public func usePost<T: SmartCodable>(at route: String, _ options: inout RequestOptions) async throws -> T {
        return try await withCheckedContinuation { continuation in
            usePost(at: route, &options) { (result: T?, error: Error?, _) in
                if error != nil {
                    continuation.resume(throwing: error as! Never)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }

    public func usePut<T: SmartCodable>(at route: String, _ options: inout RequestOptions, completion: @escaping Completion<T>) {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.put
        useRequest(at: route, options, completion: completion)
    }

    public func usePut<T: SmartCodable>(at route: String, _ options: inout RequestOptions) async throws -> T {
        return try await withCheckedContinuation { continuation in
            usePut(at: route, &options) { (result: T?, error: Error?, _) in
                if error != nil {
                    continuation.resume(throwing: error as! Never)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }

    func url(_ path: String) -> String {
        if path.starts(with: "http") {
            return path
        }
        let environment = context.environment
        return "\(environment.url)\(path)"
    }
}
