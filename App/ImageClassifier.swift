//
//  ImageClassifier.swift
//  CodingClubCoreML
//
//  Created by Rizky Dwi Hadisaputro on 12/07/23.
//

import CoreML
import Vision
import CoreImage

class ImageClassifier {
    func classifyImage(image: CIImage, completion: @escaping (String) -> Void) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Failed to load Core ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to process image classification")
            }
            
            if let firstResult = results.first {
                completion("\(firstResult.identifier) (\(firstResult.confidence * 100)%)")
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform image classification request: \(error)")
        }
    }
}
