//
//  TMDBBEConfigurationRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TMDBBEConfigurationRepository: BEConfigurationRepository {
    private let _currentBEConfiguration: BehaviorRelay<APIConfiguration> = BehaviorRelay(value: APIConfiguration.defaultConfig)
    var currentBEConfiguration: APIConfiguration { self._currentBEConfiguration.value }
    
    private let dataStore: BEConfigurationDataStore
    private let remoteAPI: BEConfigurationRemoteAPI
    private let disposeBag = DisposeBag()
    
    init(dataStore: BEConfigurationDataStore, remoteAPI: BEConfigurationRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
        read()
    }
    
    private func read() {
        getBEConfiguration()
            .subscribe(onSuccess: {[weak self] config in
                self?._currentBEConfiguration.accept(config)
            }).disposed(by: disposeBag)
    }
    
    func getBEConfiguration() -> Single<APIConfiguration> {
        let api = remoteAPI
        let store = dataStore
        //First - try to get config from the storage.
        return dataStore.readBEConfiguration()
            .flatMap { savedConfig -> Single<APIConfiguration> in
                //Then -> check how old it is. If it was saved more than 2 days ago -> get the new one from the API and save it. If not - return the saved one.
                guard Date().since(savedConfig.dateSaved, in: .day) > 2 else { return Single.just(savedConfig.config) }
                return api.getApiConfiguration()
                    .flatMap { config in
                        store.save(configuration: config).map { $0.config }
                    }.catchErrorJustReturn(savedConfig.config)
        }.do(onSuccess: {[weak self] config in
            self?._currentBEConfiguration.accept(config)
        })
    }
}
