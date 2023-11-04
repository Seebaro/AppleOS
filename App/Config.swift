//
//  Config.swift
//  Sibaro
//
//  Created by Emran on 11/4/23.
//

import Foundation

var isDebug: Bool {
    return Bundle.main.info(for: "IsDebug") == "true" ? true : false
}

var oneSignalAppID: String {
    return Bundle.main.info(for: "OneSignalAppID")
}

var sentryDSN: String {
    return Bundle.main.info(for: "SentryDSN")
}
