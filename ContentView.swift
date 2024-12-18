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
    @State private var prompt: String = ""
    @State private var selectedSize: String = "512x512"
    
    let sizes = ["256x256", "512x512", "768x768"] // Tailles d'image prédéfinies
    
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
                
                TextField("Enter your prompt here", text: $prompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Select Image Size:")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Picker("Select Image Size", selection: $selectedSize) {
                    ForEach(sizes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: generateImage) {
                    Text(isLoading ? "Generating..." : "Generate Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                .padding()
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
            "TextEncoder.mlmodelc",
            "unet.mlmodelc",
            "VAEDecoder.mlmodelc"
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
        guard !prompt.isEmpty else {
            print("Prompt is empty. Please enter a prompt.")
            return
        }
        
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
                
                let sizeComponents = selectedSize.split(separator: "x")
                let width = Int(sizeComponents[0]) ?? 512
                let height = Int(sizeComponents[1]) ?? 512
                
                let images = try pipeline.generateImages(
                    configuration: StableDiffusionPipeline.Configuration(
                        prompt: prompt
                    )
                )
                
                if let cgImage = images.first {
                    DispatchQueue.main.async {
                        if let unwrappedCGImage = cgImage {
                            let resizedImage = NSImage(cgImage: unwrappedCGImage, size: NSSize(width: width, height: height))
                            self.generatedImage = resizedImage
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
