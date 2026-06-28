import SwiftUI
import VisionKit
import Vision

// ScannerView integrates the Apple system document scanner (VisionKit) and runs OCR (Vision) on all scanned pages.
struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onRecognizedTexts: ([String]) -> Void
    var onError: (Error) -> Void
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView
        
        init(parent: ScannerView) {
            self.parent = parent
        }
        
        // Delegate method triggered when user saves the scan.
        // It can contain multiple pages if the user scans successively.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            if scan.pageCount > 0 {
                performOCROnAllPages(scan: scan)
            } else {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.onError(error)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // Run OCR on all scanned pages in parallel
        private func performOCROnAllPages(scan: VNDocumentCameraScan) {
            let group = DispatchGroup()
            var recognizedTexts = Array(repeating: "", count: scan.pageCount)
            
            for i in 0..<scan.pageCount {
                group.enter()
                let image = scan.imageOfPage(at: i)
                guard let cgImage = image.cgImage else {
                    group.leave()
                    continue
                }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                let request = VNRecognizeTextRequest { request, error in
                    defer { group.leave() }
                    
                    if error == nil, let observations = request.results as? [VNRecognizedTextObservation] {
                        let text = observations.compactMap { observation in
                            observation.topCandidates(1).first?.string
                        }.joined(separator: "\n")
                        
                        recognizedTexts[i] = text
                    }
                }
                
                request.recognitionLevel = .accurate
                request.recognitionLanguages = ["tr-TR", "en-US"]
                request.usesLanguageCorrection = true
                
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        try requestHandler.perform([request])
                    } catch {
                        print("OCR failed for page \(i): \(error.localizedDescription)")
                    }
                }
            }
            
            // Trigger completion callback on the main thread once all pages are processed
            group.notify(queue: .main) {
                let validTexts = recognizedTexts.filter { !$0.isEmpty }
                self.parent.onRecognizedTexts(validTexts)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // No update needed
    }
}
