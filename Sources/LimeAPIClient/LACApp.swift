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
    
    /// Возвращает значение, вычисленное на основе номер релиза или версии пакета,
    /// либо пустую строку (_при отсутствии указанных данных_).
    ///
    /// Номер релиза или версия пакета определяется ключом [CFBundleShortVersionString](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring).
    ///
    /// Формат - это три целых числа, разделенных точками, например 10.14.1. Строка может содержать только числовые символы (0-9) и точки.
    ///
    /// Каждое целое число содержит информацию о выпуске в формате [*Значительный*].[*Незначительный*].[*Патч*]:
    ///
    /// - **Значительный**: номер редакции значительных изменений.
    /// - **Незначительный**: номер редакции незначительных изменений.
    /// - **Патч**: номер редакции устранения ошибок.
    ///
    /// **Вычисление значения.** Если числа *Незначительный* и *Патч* содеражат только 1 цифру,
    /// то они добавляются спереди нулями до двухзначного значения, в противном случае оставляются как есть,
    /// например для версии 10.14.1 это будет 10.14.01.
    /// После чего убираются разделения в виде точек.
    ///
    /// **Внимание.** В текущей реализации недопустимо указывать в числах *Незначительный* и *Патч* более 2 цифр!
    static func versionCode(from verion: String = LACApp.version) -> String {
        var components = verion.split(separator: ".")
        
        if components.isEmpty {
            return ""
        } else if components.count < 3 {
            let append = 3 - components.count
            (0..<append).forEach { _ in
                components.append("00")
            }
        }
        
        return components.enumerated().map { (index, number) -> String in
            if index > 0 && number.count < 2 {
                return "0" + number
            }
            return String(number)
        }.joined()
    }
    
    
}
