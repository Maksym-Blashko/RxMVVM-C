//
//  AppSettings.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 08.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//
import Foundation

enum SettingsKey: String {
    case apiKey
    case environment
}

enum Environment: String {
    case dev, production
}

struct AppSettings {
    static var shared = AppSettings()
    let apiKey: String
    let environment: Environment
    
    private init() {
        guard let settings = Bundle.main.object(forInfoDictionaryKey: "AppSettings") as? [String: String] else { fatalError("Something wrong with AppSettings dictionary") }
        apiKey = settings[SettingsKey.apiKey.rawValue].required()
        environment = Environment(rawValue: settings[SettingsKey.environment.rawValue].required())
            .required(error: "Env info is missing")
    }
}
