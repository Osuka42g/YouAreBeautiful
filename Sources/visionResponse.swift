//
//  visionResponse.swift
//  YouAreBeautifulKitura
//
//  Created by Oscar Mendoza Ochoa on 5/18/17.
//
//
import SwiftyJSON
import Foundation

public class visionResponse {

    var safeSearch: JSON?
    var webDetection: JSON?
    var labelAnnotations: JSON?
    
    init(_ input: JSON) {
        safeSearch = input["responses"][0]["safeSearchAnnotation"]
        webDetection = input["responses"][0]["webDetection"]
        labelAnnotations = input["responses"][0]["labelAnnotations"]
    }
    
    func countWebDetectionResults() -> Int {
        if webDetection == nil { return 0 }
        
        var count = 0
        
        for label in webDetection! {
            count += label.1.count
//            print(label)
        }
        return count
    }
    
}
