//
//  GetMediaData.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import Foundation

struct GetMediaData {
    func getMediadata<T:Decodable>(fileName: String, resultType: T.Type, completionHandler:(_ result: T)-> Void){
        do {
            let url = Bundle.main.url(forResource: fileName, withExtension: "json")
            if url==nil {
                return
            }
            let data = try Data(contentsOf: url!)
            let response = try JSONDecoder().decode(T.self, from: data)
            _=completionHandler(response)
        }
        catch let decodingError {
            debugPrint(decodingError)
        }
    }
}


