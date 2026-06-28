import SwiftUI

// ContentView provides the main list view, summaries, export functionalities, and entry points for scanning.
struct ContentView: View {
    @State private var items: [ReceiptItem] = []
    
    @State private var isShowingScanner = false
    @State private var editingItem: ReceiptItem? = nil
    @State private var isCopied = false
    @State private var isShowingClearAlert = false
    
    private var totalAmountSum: Double {
        items.reduce(0) { $0 + $1.totalAmount }
    }
    
    private var totalKdvSum: Double {
        items.reduce(0) { $0 + $1.kdvAmount }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Statistics/Summary Card at the top
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Toplam Tutar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            Text(formatCurrency(totalAmountSum))
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Toplam KDV")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            Text(formatCurrency(totalKdvSum))
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                // List content
                if items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.6))
                        Text("Henüz fiş taranmadı.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Sağ üstteki kamera düğmesine basarak ardışık şekilde fiş tarayabilirsiniz.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(items) { item in
                            // Tap on any item in the list to edit/correct it
                            Button(action: {
                                editingItem = item
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.companyName)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(formatDate(item.date))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text(formatCurrency(item.totalAmount))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("KDV: \(formatCurrency(item.kdvAmount))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Export and controls overlay at the bottom
                if !items.isEmpty {
                    VStack(spacing: 12) {
                        if isCopied {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Excel formatında panoya kopyalandı!")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .fontWeight(.medium)
                            }
                            .transition(.opacity)
                        }
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                // Share CSV Button
                                Button(action: {
                                    shareCSV()
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Paylaş (.CSV)")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                }
                                
                                // Copy TSV string to clipboard
                                Button(action: {
                                    copyToClipboard()
                                }) {
                                    HStack {
                                        Image(systemName: "doc.on.doc")
                                        Text("Panoya Kopyala")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentColor)
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Clear list button
                            Button(action: {
                                isShowingClearAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Listeyi Temizle")
                                }
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Fişlerim")
            .navigationBarItems(
                trailing: Button(action: {
                    isShowingScanner = true
                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.title2)
                }
            )
            .sheet(isPresented: $isShowingScanner) {
                ScannerView(
                    onRecognizedTexts: { texts in
                        processScannedTexts(texts)
                    },
                    onError: { error in
                        print("Scanner failed with error: \(error.localizedDescription)")
                    }
                )
            }
            .sheet(item: $editingItem) { item in
                ResultEditView(
                    companyName: item.companyName,
                    totalAmount: item.totalAmount,
                    kdvAmount: item.kdvAmount,
                    rawText: item.rawText,
                    onSave: { updatedItem in
                        if let index = items.firstIndex(where: { $0.id == item.id }) {
                            items[index] = updatedItem
                            items[index].id = item.id // Preserve ID
                            saveItemsToStorage()
                        }
                    }
                )
            }
            .alert("Listeyi Temizle?", isPresented: $isShowingClearAlert) {
                Button("İptal", role: .cancel) { }
                Button("Temizle", role: .destructive) {
                    clearAllItems()
                }
            } message: {
                Text("Tüm taranan fiş verileriniz silinecektir. Bu işlem geri alınamaz.")
            }
            .onAppear(perform: loadItems)
        }
    }
    
    // Handler for successful OCR scanning of multiple pages
    private func processScannedTexts(_ texts: [String]) {
        for text in texts {
            let result = ReceiptParser.parse(rawText: text)
            let newItem = ReceiptItem(
                companyName: result.companyName,
                totalAmount: result.totalAmount,
                kdvAmount: result.kdvAmount,
                rawText: text
            )
            items.append(newItem)
        }
        saveItemsToStorage()
    }
    
    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItemsToStorage()
    }
    
    private func clearAllItems() {
        items.removeAll()
        saveItemsToStorage()
    }
    
    // Copy the receipt data formatted as TSV lines to clipboard.
    private func copyToClipboard() {
        var tsvText = "Firma Adı\tToplam Tutar\tKDV\n"
        for item in items {
            tsvText += "\(item.tsvLine)\n"
        }
        
        UIPasteboard.general.string = tsvText
        
        withAnimation {
            isCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                isCopied = false
            }
        }
    }
    
    private func saveItemsToStorage() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "ScannedReceipts")
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "ScannedReceipts"),
           let decoded = try? JSONDecoder().decode([ReceiptItem].self, from: data) {
            items = decoded
        }
    }
    
    private func formatCurrency(_ val: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: val)) ?? String(format: "%.2f ₺", val)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    // Computed property to generate the CSV string with semicolons and Turkish localized formatting
    private var csvContent: String {
        var text = "Firma Adı;Toplam Tutar;KDV\n"
        for item in items {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = ""
            
            let totalStr = formatter.string(from: NSNumber(value: item.totalAmount)) ?? String(format: "%.2f", item.totalAmount).replacingOccurrences(of: ".", with: ",")
            let kdvStr = formatter.string(from: NSNumber(value: item.kdvAmount)) ?? String(format: "%.2f", item.kdvAmount).replacingOccurrences(of: ".", with: ",")
            
            text += "\(item.companyName);\(totalStr);\(kdvStr)\n"
        }
        return text
    }
    
    // Writes CSV string to a temporary file URL with UTF-8 BOM so Excel opens it with correct Turkish characters.
    private func getCSVFileURL() -> URL? {
        let csvString = csvContent
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("fisler.csv")
        
        do {
            let bom = "\u{FEFF}" // Byte Order Mark for UTF-8 (Excel requires this to show Turkish characters correctly)
            let csvWithBOM = bom + csvString
            try csvWithBOM.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Failed to write CSV file: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Presents the system Share Sheet (UIActivityViewController) with the CSV file URL.
    private func shareCSV() {
        guard let fileURL = getCSVFileURL() else { return }
        
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // Setup popover for iPad support to prevent crashes
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = rootVC.view
                popoverController.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
