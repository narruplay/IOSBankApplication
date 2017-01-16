//
//  CallbackResult.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class CallbackResult<T>: NSObject {

    var error : CallbackError? = nil{
        didSet{
            isError = true
        }
    }
    var object : T? = nil
    
    var isError : Bool = false
    
    init(object : T){
        self.object = object
    }
    
    init (error : CallbackError){
        self.error = error
    }

}

enum CallbackError : Error{
    case DataBaseReadError
    case BankListAPILoadError
    case BankDetailAPILoadError
    case JSONParseError
    case PhoneParseError
    case DataBaseNoDataError
    case DataBaseSaveError
    case ConnectionError
    
    func message()->String{
        switch self {
            case .DataBaseReadError:
                return "Ощибка загрузки данных из базы данных"
            case .BankListAPILoadError:
                return "Ошибка загрузки списка банков. Проверьте подключение или поробуйте позднее"
            case .BankDetailAPILoadError:
                return "Ошибка загрузке детальной информации о банке. Проверьте оединение или попробуйте позднее"
            case .JSONParseError:
                return "Некорректный формат данных"
            case .PhoneParseError:
                return "Ошибка преобразования номера телефона, неверный формат данных"
            case .DataBaseNoDataError:
                return "Нет запрашиваемых данных"
            case .DataBaseSaveError:
                return "Ошибка при сохранении данных"
            case .ConnectionError:
                return "Проверьте соединение с интернетом или попробуйте позднее"

        }
    }
    
    func title()-> String{
        switch self {
            case .DataBaseReadError:
                return "Ошибка загрузки данных"
            case .BankListAPILoadError:
                return "Ошибка загрузки данных"
            case .BankDetailAPILoadError:
                return "Ошибка загрузки данных"
            case .JSONParseError:
                return "Ошибка загрузки данных"
            case .PhoneParseError:
                return "Ошибка парсинга телефона"
            case .DataBaseNoDataError:
                return "Ошибка поиска данных"
            case .DataBaseSaveError:
                return "Ошибка записи данных"
            case .ConnectionError:
                return "Сервис недоступен"
        }
    }
}
