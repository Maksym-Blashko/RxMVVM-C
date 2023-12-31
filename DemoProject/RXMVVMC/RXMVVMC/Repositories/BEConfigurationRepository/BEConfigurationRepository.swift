//
//  BEConfigurationRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

protocol BEConfigurationRepository {
    ///Returns APIConfiguration either from storage, or remote API
    func getBEConfiguration() -> Single<APIConfiguration>
    ///Returns the stored configuration
    var currentBEConfiguration: APIConfiguration { get }
}
