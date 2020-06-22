//
//  LACApp.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

/// Получение данных об используемом приложении.
public struct LACApp {
    /// Возвращает идентификатор пакета, который определяется ключом [CFBundleIdentifier](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier) из списка информационных свойств пакета, либо пустую строку.
    public static var id: String {
        Bundle.main.bundleIdentifier ?? ""
    }
    
    /// Возвращает номер релиза или версии пакета, либо пустую строку.  Oпределяется ключом [CFBundleShortVersionString](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring).
    ///
    /// Формат - это три целых числа, разделенных точками, например 10.14.1. Строка может содержать только числовые символы (0-9) и точки.
    ///
    /// Каждое целое число содержит информацию о выпуске в формате [*Значительный*].[*Незначительный*].[*Патч*]:
    ///
    /// - **Значительный**: номер редакции значительных изменений.
    /// - **Незначительный**: номер редакции незначительных изменений.
    /// - **Патч**: номер редакции устранения ошибок.
    static var version: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
}
