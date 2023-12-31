//
//  UDBEConfigurationDataStore.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

/**
 Implementation of the BEConfigurationDataStore
 Uses UserDafaults as backed storage.
 */
class UDBEConfigurationDataStore: BEConfigurationDataStore {
    @UDStorage(key: "rxmvvmc.BEAPIConfiguration", defaultValue: SavedApiConfiguration.defaultConfig)
    var apiConfiguration: SavedApiConfiguration
    
    ///Returns the
    func readBEConfiguration() -> Single<SavedApiConfiguration> {
        let config = apiConfiguration
        return Single.deferred { Single.just(config) }
    }
    
    func save(configuration: APIConfiguration) -> Single<SavedApiConfiguration> {
        Single<SavedApiConfiguration>.create {[unowned self] single -> Disposable in
            let container = SavedApiConfiguration(config: configuration, dateSaved: Date())
            self.apiConfiguration = container
            single(.success(container))
            return Disposables.create()
        }
    }
}
