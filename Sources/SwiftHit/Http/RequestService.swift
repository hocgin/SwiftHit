//
//  AlamofireService.swift
//  app-starter
//
//  Created by hocgin on 2024/1/18.
//

import Alamofire
import Foundation
import SmartCodable

protocol ApiEnvironment {
    var url: String { get }
}

class ApiContext {
    var environment: ApiEnvironment
    init(environment: ApiEnvironment) {
        self.environment = environment
    }

}

struct Options {
    var headers: HTTPHeaders?
    var body: Parameters? = nil
    var method: HTTPMethod?
    var encoding: ParameterEncoding?
}

typealias Completion<T> = (_ data: T?, _ error: Error?, _ resp: AFDataResponse<Data?>) -> Void

// https://github.com/intsig171/SmartCodable
// https://github.com/tristanhimmelman/ObjectMapper
// https://danielsaidi.com/blog/2018/12/27/alamofire-objectmapper
// https://medium.com/@tomasparizek/alamofire-objectmapper-must-have-combo-for-any-ios-developer-d5c25623562
class RequestService {
    init(context: ApiContext) {
        self.context = context
    }

    var context: ApiContext

    func get(at route: String) -> DataRequest {
        let options = Options(method: .get, encoding: URLEncoding.default)
        return request(at: route, options)
    }

    func post(at route: String, _ options: inout Options) -> DataRequest {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.post
        return request(at: route, options)
    }

    func put(at route: String, _ options: inout Options) -> DataRequest {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.put
        return request(at: route, options)
    }

    func request(at route: String, _ options: Options) -> DataRequest {
        let url = url(route)
        let method = options.method!
        let params = options.body ?? [:]
        let headers = options.headers ?? [:]
        let encoding = options.encoding!

        print("请求 \(method.rawValue) \(url)")
        return AF.request(url, method: method, parameters: params, encoding: encoding, headers: headers).validate()
    }

    func useRequest<T: SmartCodable>(at route: String, _ options: Options,
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

    func useRequest<T: SmartCodable>(at route: String, _ options: Options) async throws -> T {
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

    func useGet<T: SmartCodable>(at route: String) async throws -> T {
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

    func useGet<T: SmartCodable>(at route: String, completion: @escaping Completion<T>) {
        let options = Options(method: .get, encoding: URLEncoding.default)
        useRequest(at: route, options, completion: completion)
    }

    func usePost<T: SmartCodable>(at route: String, _ options: inout Options, completion: @escaping Completion<T>) {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.post
        useRequest(at: route, options, completion: completion)
    }

    func usePost<T: SmartCodable>(at route: String, _ options: inout Options) async throws -> T {
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

    func usePut<T: SmartCodable>(at route: String, _ options: inout Options, completion: @escaping Completion<T>) {
        options.encoding = options.encoding ?? JSONEncoding.default
        options.method = options.method ?? HTTPMethod.put
        useRequest(at: route, options, completion: completion)
    }

    func usePut<T: SmartCodable>(at route: String, _ options: inout Options) async throws -> T {
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
