//
//  ContentView.swift
//  Screenable
//
//  Created by Jaime Yesid Leon Parada on 14/06/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Binding var document: ScreenableDocument
    
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")
    
    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
                .onDrop(of: [UTType.fileURL], isTargeted: nil, perform: handleDrop)
                .onDrag {
                    let url = FileManager.default.temporaryDirectory.appendingPathComponent("ScreenableExport").appendingPathExtension("png")
                    try? RenderView(document: document).snapshot()?.write(to: url)
                    
                    return NSItemProvider(item: url as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                }
            
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption").bold()
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                    Picker("Select a caption font", selection: $document.font){
                        ForEach(fonts, id: \.self, content: Text.init)
                    }
                    
                    HStack {
                        Picker("Size of caption font", selection: $document.fontSize){
                            ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self){ size in
                                Text("\(size)pt")
                            }
                        }
                        
                        ColorPicker("Caption color", selection: $document.captionColor)
                    }
                }
                .labelsHidden()
                
                VStack(alignment: .leading) {
                    Text("Background image")
                        .bold()
                    Picker("Background image", selection: $document.backgroundImage) {
                        Text("No background image").tag("")
                        Divider()
                        ForEach(backgrounds, id: \.self, content: Text.init)
                    }
                }
                .labelsHidden()
                
                VStack(alignment: .leading) {
                    Text("Background color").bold()
                    Text("if set to non-transparent, this will be drawn over the background image.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 20) {
                        ColorPicker("Start:", selection: $document.backgroundColorTop)
                        ColorPicker("End:", selection: $document.backgroundColorBottom)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Drop shadow").bold()
                    Picker("Drop shadow location", selection: $document.dropShadowLocation) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Device").tag(2)
                        Text("Both").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()

                    Stepper("Shadow radious: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
                }
            }
            .frame(width: 250)
        }
        .padding()
        .toolbar {
            Button("Export..", action: export)
        }
        .onCommand(#selector(AppCommands.export), perform: export)
    }
    
    // 1.
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        // 2.
        guard let item = providers.first else { return false}
        // 3.
        item.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { data, error in
            //4.
            if let data = data as? Data {
                guard let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                // 5.
                let loadedImage = try? Data(contentsOf: url)
                // 6.
                Task { @MainActor in
                    document.userImage = loadedImage
                }
            }
        }
        // 7.
        return true
    }
    
    func export() {
        guard let png = RenderView(document: document).snapshot() else { return }
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.begin { result in
            if result == .OK {
                guard let url = panel.url else { return }
                
                do {
                    try png.write(to: url)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ScreenableDocument()))
    }
}
