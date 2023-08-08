import SwiftUI
import Vision

struct ContentView: View {
    @State private var showImagePicker = false
    @State var selectedImage: UIImage?
    @State var classificationResults = [VNClassificationObservation]()
    @State private var showActionSheet = false
    @State private var selectedSourceType: UIImagePickerController.SourceType?
    
    var body: some View {
        VStack {
            Button("Select Image") {
                self.showActionSheet = true
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            List(classificationResults, id: \.self) { result in
                let confidencePercentage = Int(result.confidence * 100)
                Text("\(result.identifier): \(confidencePercentage)%")
            }
            //ambil nilai tertinggi
            //            if let firstResult = classificationResults.prefix(1).first {
            //                Text("\(firstResult.identifier): \(firstResult.confidence)")
            //            }
            
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Select Image"), message: nil, buttons: [
                .default(Text("Camera"), action: {
                    self.showImagePicker = true
                    self.selectedImage = nil
                    self.selectedSourceType = .camera
                }),
                .default(Text("Photo Library"), action: {
                    self.showImagePicker = true
                    self.selectedImage = nil
                    self.selectedSourceType = .photoLibrary
                }),
                .cancel()
            ])
        }
        
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$selectedImage, sourceType: self.selectedSourceType ?? .camera, onImagePicked: self.performImageClassification)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
