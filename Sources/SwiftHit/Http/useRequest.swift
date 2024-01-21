//
//  useRequest.swift
//  app-starter
//
//  Created by hocgin on 2024/1/21.
//

import Foundation
import SmartCodable
import SwiftUI

public typealias ComplexService<Result: SmartCodable, Params: Any> = (_ params: Params?) async -> Result

public struct URequestOptions<Result: SmartCodable> {
    var manual: Bool = false
    var onBefore: (() -> Void)?
    var onSuccess: ((_ data: Result) -> Void)?
    var onError: ((_ error: Error) -> Void)?
    var onFinaly: (() -> Void)?
}

public enum RequestError: Error {
    case DuplicateRequest
}

// public func useRequest<Result: SmartCodable>(_ service: @escaping ComplexService<Result>,
//                                             options: URequestOptions<Result>? = nil,
//                                             manual: Bool = false,
//                                             onBefore: (() -> Void)? = nil,
//                                             onSuccess: ((_ data: Result) -> Void)? = nil,
//                                             onError: @escaping ((_ error: Error) -> Void)? = nil,
//                                             onFinaly: @escaping (() -> Void)? = nil) -> UseRequest<Result>
// {
//    return UseRequest(service, options: options, manual: manual, onBefore: onBefore, onSuccess: onSuccess, onError: onError, onFinaly: onFinaly)
// }

open class UseRequest<Result: SmartCodable, Params: Any>: ObservableObject {
    @Published public var loading: Bool = false
    var service: ComplexService<Result, Params>
    var options: URequestOptions<Result>?
    var defaultParams: Params?
    var manual: Bool = false
    var onBefore: (() -> Void)?
    var onSuccess: ((_ data: Result) -> Void)?
    var onError: ((_ error: Error) -> Void)?
    var onFinaly: (() -> Void)?

    private var inited = false

    init(_ service: @escaping ComplexService<Result, Params>,
         options: URequestOptions<Result>? = nil,
         manual: Bool = false,
         defaultParams: Params? = nil,
         onBefore: (() -> Void)? = nil,
         onSuccess: ((_ data: Result) -> Void)? = nil,
         onError: ((_ error: Error) -> Void)? = nil,
         onFinaly: (() -> Void)? = nil)
    {
        self.service = service
        self.options = options
        self.manual = manual
        self.onBefore = onBefore
        self.onSuccess = onSuccess
        self.onError = onError
        self.onFinaly = onFinaly
        self.defaultParams = defaultParams
        _init()
    }

    /**
     初始化操作
     */
    func _init() {
        if inited {
            return
        }
        inited = true
        if manual == false {
            print("初始化操作")
            Task { await try? self._run() }
        }
    }

    public func run(_ params: Params? = nil) async {
        try? await _run(params)
    }

    private func _run(_ params: Params? = nil) async throws -> Result {
        if loading {
            print("正在请求中，拦截恶意点击")
            throw RequestError.DuplicateRequest
        }
        DispatchQueue.main.async { [weak self] in
            self?.onBefore?()
        }
        loading = true
        var result: Result
        do {
            print("发起请求网络")
            result = try await service(params ?? defaultParams)
            DispatchQueue.main.async { [weak self, result] in
                self?.onSuccess?(result)
                self?.onFinaly?()
            }
        } catch {
            DispatchQueue.main.async { [weak self, error] in
                self?.onError?(error)
                self?.onFinaly?()
            }
        }
        loading = false
        return result
    }

    public func refresh() async {
        try? await _run()
    }
}

/**

 import CoreData
 import SwiftHit
 import SwiftUI
 import ToastViewSwift

 class ViewModel: ObservableObject {
     @Published var resultStr = "unrequest"
     lazy var fetch: UseRequest<Result<ExampleData>, Any> = UseRequest(
         { _ in
             await AppService.shared.getMovie3(id: 1)
         },
         manual: false,
         onSuccess: { [weak self] _ in
             self?.resultStr = "requested \(Date())"
         }
     )

     func runFetch() async {
         await fetch.run()
     }
 }

 // swift weak self unowned self
 struct ContentView: View {
     @ObservedObject var vm = ViewModel()

     var body: some View {
         VStack {
             Button("Test Http") {
                 Task {
                     let result = try? await AppService.shared.getMovie3(id: 1)
                     print("shared.getMovie3 = \(result?.toJSONString() ?? "")")
                 }
             }

             Button("Test Http.useRequest \(vm.resultStr) loading=\(String(vm.fetch.loading))") {
                 Task {
                     await self.vm.runFetch()
                 }
             }

             Button("Test CoreData.Select") {
                 let list = TaskEntityService.shared.selectList()
                 print("list = \(list)")
             }

             Button("Test CoreData.Insert") {
                 let entity = TaskEntityService.shared.insertNewObject()
                 entity.title = "Name"
                 entity.timestamp = Date()

                 entity.save()
                 print("result = \(entity)")
             }
         }
     }
 }

 */
