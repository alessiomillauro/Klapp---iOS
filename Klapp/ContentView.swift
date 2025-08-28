//
//  ContentView.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

import SwiftUI

var imageLoader = ImageLoader()

class ImageLoader {
    var images : [Image] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        
        for _ in 0..<10 {
            images.append( Image(systemName: "circle.fill"))
        }
    }
}
