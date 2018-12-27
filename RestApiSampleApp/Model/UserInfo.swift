//
//  UserInfo.swift
//  RestApiSampleApp
//
//  Created by Karthik on 27/12/18.
//  Copyright © 2018 k4. All rights reserved.
//

import Foundation
import UIKit

struct UserInfo:Codable {
    var emailId:String?
    var imageUrl:String?
    var firstName:String?
    var lastName:String?
    var image:Data?
    
    private enum CodingKeys: String, CodingKey {
        case emailId
        case imageUrl
        case firstName
        case lastName
    }
    
    mutating func downloadPhotoData(_ url: String?) -> Data?{
        
        let imgrl = URL(string: url!)
        var data:Data?
        if let theProfileImageUrl = imgrl {
            do {
                data = try Data(contentsOf: theProfileImageUrl as URL)
                
            } catch {
                print("Unable to load data: \(error)")
            }
            return data
        }
        return nil
    }
    
}
