//
//  BEConfigurationRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

protocol BEConfigurationRemoteAPI {
    func getApiConfiguration() -> Single<APIConfiguration>
}
