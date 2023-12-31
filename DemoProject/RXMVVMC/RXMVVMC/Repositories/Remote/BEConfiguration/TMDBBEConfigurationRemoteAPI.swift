//
//  TMDBBEConfigurationRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
enum BEConfigurationAPIError: Error {
    case failedToGetApiConfiguration
}

extension BEConfigurationAPIError: LocalizedError {
    var errorDescription: String? {"Failed to get API configuration"}
}

struct TMDBBEConfigurationRemoteAPI: BEConfigurationRemoteAPI {
    
    let router: APIRouter<BEConfiguration>
    
    init(router: APIRouter<BEConfiguration>) {
        self.router = router
    }
    
    func getApiConfiguration() -> Single<APIConfiguration> {
        let router = self.router
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = router.request(.getApiConfig(apiKey: apiKey), responseHandler: nil) { (result: Result<APIConfiguration, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let config):
                    single(.success(config))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }.observeOn(MainScheduler.instance)
    }
}
