//
//  ContentView.swift
//  Stable-Diffusion-Macos2
//
//  Created by Jossua Figueiras on 15/12/2024.
//
import SwiftUI
import StableDiffusion
import CoreML

struct ContentView: View {
    @State private var generatedImage: NSImage? = nil
    @State private var isLoading = false
    @State private var missingFiles: [String] = []
    
    var body: some View {
        VStack {
            if missingFiles.isEmpty {
                if let image = generatedImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 300, height: 300)
                        .overlay(Text("No Image Generated").foregroundColor(.white))
                }
                Button(action: generateImage) {
                    Text(isLoading ? "Generating..." : "Generate Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
            } else {
                VStack {
                    Text("Missing required files:")
                        .font(.headline)
                        .foregroundColor(.red)
                    ForEach(missingFiles, id: \.self) { file in
                        Text(file)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            checkRequiredFiles()
        }
    }
    
    func checkRequiredFiles() {
        guard let resourceURL = Bundle.main.resourceURL else {
            print("Error: Unable to find resource URL")
            return
        }
        
        let requiredFiles = [
            "text_encoder.mlmodelc",
            "unet.mlmodelc",
            "vae_decoder.mlmodelc"
        ]
        
        let missing = requiredFiles.filter { fileName in
            let fileURL = resourceURL.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                print("Missing file: \(fileName) expected at \(fileURL.path)")
                return true
            }
            return false
        }
        
        DispatchQueue.main.async {
            missingFiles = missing
        }
        
        if missing.isEmpty {
            print("All required files are present.")
        } else {
            print("Some required files are missing: \(missing)")
        }
    }
    
    func generateImage() {
        guard missingFiles.isEmpty else {
            print("Cannot generate image. Missing files: \(missingFiles)")
            return
        }
        
        isLoading = true
        let workItem = DispatchWorkItem {
            do {
                guard let resourceURL = Bundle.main.resourceURL else {
                    print("Error: Unable to find resource URL")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                let configuration = MLModelConfiguration()
                let controlNet: [String] = []
                
                let pipeline = try StableDiffusionPipeline(
                    resourcesAt: resourceURL,
                    controlNet: controlNet,
                    configuration: configuration
                )
                let images = try pipeline.generateImages(
                    configuration: StableDiffusionPipeline.Configuration(prompt: "a photo of an astronaut riding a horse on mars")
                )
                if let cgImage = images.first {
                    DispatchQueue.main.async {
                        if let unwrappedCGImage = cgImage {
                            let width = unwrappedCGImage.width
                            let height = unwrappedCGImage.height
                            self.generatedImage = NSImage(cgImage: unwrappedCGImage, size: NSSize(width: width, height: height))
                        }
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to generate image: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: workItem)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
