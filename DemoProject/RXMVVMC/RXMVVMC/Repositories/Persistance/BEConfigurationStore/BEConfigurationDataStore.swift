//
//  BEConfigurationDataStore.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

protocol BEConfigurationDataStore {
    ///Reads the configuration from the storage and emits it into the stream.
    func readBEConfiguration() -> Single<SavedApiConfiguration>
    ///Saves the new configuration to the storage, wraps it into the SavedApiConfiguration container and emits it into the stream.
    func save(configuration: APIConfiguration) -> Single<SavedApiConfiguration>
}
