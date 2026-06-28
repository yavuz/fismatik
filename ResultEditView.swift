import SwiftUI

// ResultEditView is a screen where the user reviews, modifies, and approves the extracted values before saving.
struct ResultEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var companyName: String
    @State private var totalAmountString: String
    @State private var kdvAmountString: String
    
    var rawText: String
    var onSave: (ReceiptItem) -> Void
    
    init(companyName: String, totalAmount: Double, kdvAmount: Double, rawText: String, onSave: @escaping (ReceiptItem) -> Void) {
        _companyName = State(initialValue: companyName)
        // Format values with comma as the decimal separator for user input convenience
        _totalAmountString = State(initialValue: String(format: "%.2f", totalAmount).replacingOccurrences(of: ".", with: ","))
        _kdvAmountString = State(initialValue: String(format: "%.2f", kdvAmount).replacingOccurrences(of: ".", with: ","))
        self.rawText = rawText
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fiş Bilgileri")) {
                    HStack {
                        Text("Firma Adı")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        TextField("Firma Adı", text: $companyName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Toplam Tutar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Toplam Tutar", text: $totalAmountString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("TL")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("KDV")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("KDV", text: $kdvAmountString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("TL")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Taranan Ham Metin")) {
                    ScrollView {
                        Text(rawText)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 180)
                }
            }
            .navigationTitle("Bilgileri Doğrula")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red),
                trailing: Button("Kaydet") {
                    saveItem()
                }
                .fontWeight(.bold)
            )
        }
    }
    
    private func saveItem() {
        let totalVal = parseDouble(totalAmountString) ?? 0.0
        let kdvVal = parseDouble(kdvAmountString) ?? 0.0
        
        let item = ReceiptItem(
            companyName: companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Bilinmeyen Firma" : companyName,
            totalAmount: totalVal,
            kdvAmount: kdvVal,
            rawText: rawText
        )
        
        onSave(item)
        presentationMode.wrappedValue.dismiss()
    }
    
    // Parses a decimal number input from the user (handles both dot and comma locales)
    private func parseDouble(_ text: String) -> Double? {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        if let val = formatter.number(from: cleanText)?.doubleValue {
            return val
        }
        formatter.decimalSeparator = "."
        if let val = formatter.number(from: cleanText)?.doubleValue {
            return val
        }
        
        return Double(cleanText.replacingOccurrences(of: ",", with: "."))
    }
}
