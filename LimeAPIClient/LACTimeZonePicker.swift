//
//  LACTimeZonePicker.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 22.07.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

/// Параметр `TimeZonePicker` при запросе `requestChannelsByGroupId`
/// Что отдавать если поток с нужным часовым поясом не найден. Действует только если указан часовой пояс
public enum LACTimeZonePicker: String {
    /// Параметр по умолчанию для `TimeZonePicker` при запросе `requestChannelsByGroupId`
    case previous
    case next
    case nothing
}
