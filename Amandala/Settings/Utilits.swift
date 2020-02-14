//
//  Utilits.swift
//  Amandala
//
//  Created by Денис Марков on 14.02.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation

class Utilits {
    
    func saveImageToDirectory(savingImage: UIImage?) {
        let fileManager = FileManager.default
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmssa"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(convertedDate).png")
        let image = savingImage
        let imageData = image?.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func deleteImageFromDirectory(pathSelectedImagesFromGallery: String?) {
        if let path = pathSelectedImagesFromGallery {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                debugPrint("failed to read directory – bad permissions, perhaps?")
            }
        }
    }
}
