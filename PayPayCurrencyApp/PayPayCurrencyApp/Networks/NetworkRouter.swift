//
//  NetworkRouter.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import Moya

protocol NetworkRouter: class {
    associatedtype T
    
    var provider: MoyaProvider<MultiTarget> { get }
    func request<O: Decodable>(target: T, completion: @escaping Response<O>)
}

class Router<Target: TargetType>: NetworkRouter {
    typealias T = Target
    
    var provider: MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(
            plugins: [
                NetworkLoggerPlugin(
                    configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)
                )
            ]
        )
    }
    
    func request<O: Decodable>(target: Target, completion: @escaping Response<O>) {
        provider.request(MultiTarget(target)) { response in
            switch response {
            case .success(let response):
                do {
                    if let errorResponse = try? response.filterSuccessfulStatusCodes().map(ErrorResponse.self) {
                        
                        completion(nil, NSError(domain: errorResponse.error.type,
                                                  code: errorResponse.error.code,
                                              userInfo: [NSLocalizedDescriptionKey : errorResponse.error.info]))
                        return
                    }
                    
                    completion(try response.filterSuccessfulStatusCodes().map(O.self), nil)
                }
                catch (let error) {
                    completion(nil, error)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
