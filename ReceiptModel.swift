import Foundation

// ReceiptItem represents a single scanned receipt.
// It conforms to Codable for easy persistence in UserDefaults.
struct ReceiptItem: Identifiable, Codable {
    var id = UUID()
    var date = Date()
    var companyName: String
    var totalAmount: Double
    var kdvAmount: Double
    var rawText: String
    
    // Formats the item as a Tab-Separated Values (TSV) line.
    // Uses comma (",") as the decimal separator to match Turkish Excel localization.
    var tsvLine: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "" // No thousands separator to avoid Excel parsing issues
        
        let totalStr = formatter.string(from: NSNumber(value: totalAmount)) ?? String(format: "%.2f", totalAmount).replacingOccurrences(of: ".", with: ",")
        let kdvStr = formatter.string(from: NSNumber(value: kdvAmount)) ?? String(format: "%.2f", kdvAmount).replacingOccurrences(of: ".", with: ",")
        
        return "\(companyName)\t\(totalStr)\t\(kdvStr)"
    }
}
