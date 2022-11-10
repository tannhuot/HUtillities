// FileManagerHelper.swift 
// HUtillities 
//
// Created by Khouv Tannhuot on 10/11/22. 
// Copyright (c) 2022 Khouv Tannhuot. All rights reserved. 
//

import Foundation

public struct FileManagerPath: RawRepresentable {
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
}

open class FileManagerHelper {
    public static let shared = FileManagerHelper()
    
    private let filemanager = FileManager.default
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//MARK: - File Manager
extension FileManagerHelper {
    // Save data
    public func saveData(dictionary:[String: Any], path: FileManagerPath) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(path.rawValue)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
            try data.write(to: fullPath)
        } catch {
            print("Failed to save data with file manager")
        }
    }
    
    // Get data
    public func getData<T: Codable>(type: T.Type, path: FileManagerPath) -> T? {
        let fullPath = getDocumentsDirectory().appendingPathComponent(path.rawValue)
        do {
            if let json = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: fullPath)) as? [String:Any] {
                let data = try? JSONDecoder().decode(T.self, from: try! JSONSerialization.data(withJSONObject: json, options: []))
                return data
            }
        } catch let error as NSError {
            print("Failed to get data with file manager \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    // Remove data
    public func removeData(path: FileManagerPath) {
        let userInfo =  getDocumentsDirectory().appendingPathComponent(path.rawValue)
        if FileManager().fileExists(atPath: userInfo.path) {
            do {
                try FileManager().removeItem(atPath: userInfo.path)
            } catch let error as NSError {
                print("Failed to remove data with file manager \(error.localizedDescription)")
            }
        } else {
            print("Failed to remove data with file manager")
        }
    }
}
