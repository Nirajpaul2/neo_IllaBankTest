//
//  MediaListingViewModel.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import Foundation

//Success Response protocol
protocol MediaListingResponseDelegate {
    func mediaListingResonse(media: MediaListingBO)
}

extension MediaListingResponseDelegate {
    func mediaListingResonse(media: MediaListingBO){}
}

// Service call
struct MediaListingViewModel {
    
    var delegate: MediaListingResponseDelegate?
    
    func getMediaData(fileName: String){
        GetMediaData().getMediadata(fileName: fileName, resultType: MediaListingBO.self) { (mediaObject) in
            DispatchQueue.main.async {
                self.delegate?.mediaListingResonse(media: mediaObject)
            }
        }
    }
    
}




