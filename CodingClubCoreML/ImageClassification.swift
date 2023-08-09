//
//  ImageClassification.swift
//  CodingClubCoreML
//
//  Created by Rizky Dwi Hadisaputro on 12/07/23.
//

import Foundation
import SwiftUI
import Vision
import CoreML

extension ContentView {
    func performImageClassification() {
        guard let image = selectedImage, let ciImage = CIImage(image: image) else {
            return
        }
        
        do {
//            let model = try VNCoreMLModel(for: MobileNetV2().model)
            let configuration = MLModelConfiguration()
            let mlModel = try? MobileNetV2(configuration: configuration)
            let model = try? VNCoreMLModel(for: mlModel?.model ?? MLModel())
            let request = VNCoreMLRequest(model: model!) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation],
                      let _ = results.first else {
                    return
                }
                
                self.classificationResults = results
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
        } catch {
            print("Error: \(error)")
        }
    }
}
