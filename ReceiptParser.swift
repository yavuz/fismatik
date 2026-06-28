import Foundation

// ReceiptParser analyzes the OCR raw text and extracts the receipt details.
struct ReceiptParser {
    
    struct ParsedReceipt {
        let companyName: String
        let totalAmount: Double
        let kdvAmount: Double
    }
    
    // Main entry point for parsing raw text lines.
    static func parse(rawText: String) -> ParsedReceipt {
        let lines = rawText.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let companyName = extractCompanyName(from: lines)
        let (totalAmount, kdvAmount) = extractAmounts(from: lines)
        
        return ParsedReceipt(
            companyName: companyName,
            totalAmount: totalAmount,
            kdvAmount: kdvAmount
        )
    }
    
    // Extract the company/merchant name from the top lines of the receipt.
    private static func extractCompanyName(from lines: [String]) -> String {
        // Look at the first 4 lines to find a likely company name.
        // We skip lines that are dates, times, phone numbers, or look like receipt metadata.
        for line in lines.prefix(4) {
            let lowerLine = line.localizedLowercase
            
            // Skip lines containing dates, times, phone numbers, or typical receipt metadata
            if lowerLine.contains("tarih") ||
               lowerLine.contains("saat") ||
               lowerLine.contains("tel:") ||
               lowerLine.contains("fiş no") ||
               lowerLine.contains("fis no") ||
               lowerLine.contains("v.d.") || // vergi dairesi
               lowerLine.contains("vd.") ||
               lowerLine.contains("no:") ||
               lowerLine.contains("mersis") {
                continue
            }
            
            // Skip lines that have only numbers and symbols
            let letters = line.filter { $0.isLetter }
            if letters.count < 3 {
                continue
            }
            
            // This is likely the company name (usually the first line)
            // Trim any leading/trailing special characters that might be OCR noise
            let cleaned = line.trimmingCharacters(in: CharacterSet.letters.inverted.subtracting(CharacterSet(charactersIn: "0123456789")))
            if !cleaned.isEmpty {
                return cleaned
            }
        }
        
        return "Bilinmeyen Firma"
    }
    
    // Extract both Total Amount and KDV from the receipt lines.
    private static func extractAmounts(from lines: [String]) -> (total: Double, kdv: Double) {
        var parsedPrices: [(value: Double, lineIndex: Int, text: String, isClaimed: Bool)] = []
        
        // 1. Find all candidate prices in the receipt
        for (index, line) in lines.enumerated() {
            let candidates = findPrices(in: line)
            for val in candidates {
                parsedPrices.append((value: val, lineIndex: index, text: line, isClaimed: false))
            }
        }
        
        // If we found no prices, return zeros
        if parsedPrices.isEmpty {
            return (0.0, 0.0)
        }
        
        // Helper to mark a price as claimed
        func claimPrice(value: Double, lineIndex: Int) {
            for i in 0..<parsedPrices.count {
                if parsedPrices[i].value == value && parsedPrices[i].lineIndex == lineIndex {
                    parsedPrices[i].isClaimed = true
                    break
                }
            }
        }
        
        // 2. Identify Total Amount
        var totalAmount = 0.0
        var totalFound = false
        
        let totalKeywords = ["toplam", "toplam:", "tutar", "tutari", "işlem tutari", "islem tutari", "top", "eft-pos", "eft pos"]
        
        // Heuristic A: Look for explicit labels on the SAME line (highest priority)
        for keyword in totalKeywords {
            for price in parsedPrices {
                let lowerLine = price.text.localizedLowercase
                if lowerLine.contains(keyword) {
                    if lowerLine.contains("kdv") || lowerLine.contains("topkdv") {
                        continue
                    }
                    totalAmount = max(totalAmount, price.value)
                    totalFound = true
                }
            }
            if totalFound {
                claimPrice(value: totalAmount, lineIndex: parsedPrices.first(where: { $0.value == totalAmount })?.lineIndex ?? -1)
                break
            }
        }
        
        // Heuristic B: Look for stacked labels (Total keyword is on a line, price is on next 1-3 lines)
        // Select the maximum price in the lookahead window as the total candidate
        if !totalFound {
            for keyword in totalKeywords {
                for (index, line) in lines.enumerated() {
                    let lowerLine = line.localizedLowercase
                    if lowerLine.contains(keyword) {
                        if lowerLine.contains("kdv") || lowerLine.contains("topkdv") {
                            continue
                        }
                        
                        var candidates: [(value: Double, lineIndex: Int)] = []
                        // Search next 3 lines for unclaimed prices
                        for nextIndex in (index + 1)...min(index + 3, lines.count - 1) {
                            let nextLinePrices = parsedPrices.filter { $0.lineIndex == nextIndex && !$0.isClaimed }
                            for p in nextLinePrices {
                                candidates.append((p.value, p.lineIndex))
                            }
                        }
                        
                        // Select the maximum price in the local block to prevent claiming KDV prematurely
                        if let bestCandidate = candidates.max(by: { $0.value < $1.value }) {
                            totalAmount = bestCandidate.value
                            claimPrice(value: totalAmount, lineIndex: bestCandidate.lineIndex)
                            totalFound = true
                            break
                        }
                    }
                    if totalFound { break }
                }
                if totalFound { break }
            }
        }
        
        // Heuristic C: Fallback to the absolute maximum price in the receipt
        if !totalFound {
            let unclaimed = parsedPrices.filter { !$0.isClaimed }
            if let maxVal = unclaimed.map({ $0.value }).max() {
                totalAmount = maxVal
                if let matched = unclaimed.first(where: { $0.value == maxVal }) {
                    claimPrice(value: maxVal, lineIndex: matched.lineIndex)
                }
                totalFound = true
            } else {
                totalAmount = parsedPrices.map { $0.value }.max() ?? 0.0
            }
        }
        
        // 3. Identify KDV Amount
        var kdvAmount = 0.0
        var kdvFound = false
        
        let kdvKeywords = ["kdv", "topkdv", "k.d.v.", "vergı", "vergi", "kdv toplam", "kdv toplamı"]
        
        // Heuristic A: Look for explicit label on the SAME line
        for price in parsedPrices {
            if price.isClaimed { continue }
            let lowerLine = price.text.localizedLowercase
            for keyword in kdvKeywords {
                if lowerLine.contains(keyword) {
                    if price.value <= totalAmount * 0.22 {
                        kdvAmount = max(kdvAmount, price.value)
                        kdvFound = true
                    }
                }
            }
        }
        if kdvFound {
            claimPrice(value: kdvAmount, lineIndex: parsedPrices.first(where: { $0.value == kdvAmount && !$0.isClaimed })?.lineIndex ?? -1)
        }
        
        // Heuristic B: Look for stacked labels (KDV keyword on a line, price on next 1-3 lines)
        if !kdvFound {
            for keyword in kdvKeywords {
                for (index, line) in lines.enumerated() {
                    let lowerLine = line.localizedLowercase
                    if lowerLine.contains(keyword) {
                        var candidates: [(value: Double, lineIndex: Int)] = []
                        // Search next 3 lines for unclaimed prices
                        for nextIndex in (index + 1)...min(index + 3, lines.count - 1) {
                            let nextLinePrices = parsedPrices.filter { $0.lineIndex == nextIndex && !$0.isClaimed }
                            // KDV must be <= 22% of total amount
                            let validPrices = nextLinePrices.filter { $0.value <= totalAmount * 0.22 }
                            for p in validPrices {
                                candidates.append((p.value, p.lineIndex))
                            }
                        }
                        
                        if let bestCandidate = candidates.max(by: { $0.value < $1.value }) {
                            kdvAmount = bestCandidate.value
                            claimPrice(value: kdvAmount, lineIndex: bestCandidate.lineIndex)
                            kdvFound = true
                            break
                        }
                    }
                    if kdvFound { break }
                }
                if kdvFound { break }
            }
        }
        
        // Heuristic C: If KDV is not explicitly labeled, search for a number that represents a valid KDV rate of the total
        if !kdvFound && totalAmount > 0 {
            let possibleKdvs = parsedPrices.filter { $0.value <= totalAmount * 0.22 && $0.value > 0 && !$0.isClaimed }
            
            let targetRates = [0.20, 0.10, 0.08, 0.01, 0.18]
            var bestDiff = Double.greatestFiniteMagnitude
            var bestCandidate: (value: Double, lineIndex: Int)? = nil
            
            for candidate in possibleKdvs {
                for rate in targetRates {
                    let expectedKdv = totalAmount * (rate / (1.0 + rate))
                    let diff = abs(candidate.value - expectedKdv)
                    
                    if diff < bestDiff && diff < (totalAmount * 0.05) {
                        bestDiff = diff
                        bestCandidate = (candidate.value, candidate.lineIndex)
                    }
                }
            }
            
            if let matched = bestCandidate {
                kdvAmount = matched.value
                claimPrice(value: kdvAmount, lineIndex: matched.lineIndex)
                kdvFound = true
            }
        }
        
        // Fallback: If still not found, search for any price that is smaller than 22% of the total amount
        if !kdvFound {
            let smallerPrices = parsedPrices.filter { $0.value <= totalAmount * 0.22 && $0.value > 0 && !$0.isClaimed }
            if let maxSmaller = smallerPrices.map({ $0.value }).max() {
                kdvAmount = maxSmaller
                if let matched = smallerPrices.first(where: { $0.value == maxSmaller }) {
                    claimPrice(value: maxSmaller, lineIndex: matched.lineIndex)
                }
                kdvFound = true
            }
        }
        
        return (totalAmount, kdvAmount)
    }
    
    // Regex helper to find and parse numbers representing currency in a text line.
    private static func findPrices(in text: String) -> [Double] {
        let lowerText = text.localizedLowercase
        
        // 1. Filter out lines containing date formats (e.g. 26-06-2026 or 21/05/2026)
        let datePattern = "\\d{2}[.\\-/]\\d{2}[.\\-/]\\d{4}"
        if let dateRegex = try? NSRegularExpression(pattern: datePattern, options: []),
           dateRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: (text as NSString).length)) != nil {
            return []
        }
        
        // 2. Filter out lines containing time formats (e.g. 19:15 or 15:50:07)
        let timePattern = "\\d{2}:\\d{2}(:\\d{2})?"
        if let timeRegex = try? NSRegularExpression(pattern: timePattern, options: []),
           timeRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: (text as NSString).length)) != nil {
            return []
        }
        
        // 3. Filter out lines with credit card masks (e.g. **** **** **** 5811)
        if lowerText.contains("****") || lowerText.contains("* * * *") {
            return []
        }
        
        // 4. Filter out other typical metadata lines that might contain non-price numbers
        let invalidKeywords = [
            "tarih", "saat", "tel:", "tel :", "mersis", "sicil",
            "v.d.", "vd.", "vkn", "tckn", "vergi dairesi",
            "z no", "zno", "ekü no", "ekü", "eku no", "eku",
            "fıs no", "fiş no", "fis no", "fişno", "islem no", "işlem no",
            "bch", "batch", "ref no", "referans", "adresi", "mah.", "cad.",
            "no:", "no :"
        ]
        
        for kw in invalidKeywords {
            if lowerText.contains(kw) {
                return []
            }
        }
        
        var results: [Double] = []
        
        // 5. Matches typical Turkish receipt currency representations:
        // Examples: *250,00, *1.610,00, 146,36, 585, 331,16, 521,5, 500,78
        let pattern = "\\*?(\\d+(?:\\.\\d{3})*(?:,\\d{1,2})|\\d+(?:,\\d{3})*(?:\\.\\d{1,2})|\\b\\d{2,5},?\\b)"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        
        let nsString = text as NSString
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
        
        for match in matches {
            let matchStr = nsString.substring(with: match.range)
            if let parsedVal = parsePriceString(matchStr) {
                // Ignore integers that look like years (e.g. 2020 to 2035) to prevent accidental date year matches
                if parsedVal >= 2020 && parsedVal <= 2035 && !matchStr.contains(",") && !matchStr.contains(".") {
                    continue
                }
                results.append(parsedVal)
            }
        }
        
        return results
    }
    
    // Parse price string (e.g. "*1.610,00" or "250,00") into a Double.
    private static func parsePriceString(_ str: String) -> Double? {
        // Remove asterisk, whitespace
        var cleaned = str.replacingOccurrences(of: "*", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle Turkish style decimals where '.' is thousands separator and ',' is decimal separator.
        // E.g., "1.610,00" -> "1610.00"
        if cleaned.contains(".") && cleaned.contains(",") {
            // Find index of dot and comma to determine order
            let dotIndex = cleaned.firstIndex(of: ".")!
            let commaIndex = cleaned.firstIndex(of: ",")!
            
            if dotIndex < commaIndex {
                // E.g. 1.610,00 -> Remove dot, replace comma with dot
                cleaned = cleaned.replacingOccurrences(of: ".", with: "")
                cleaned = cleaned.replacingOccurrences(of: ",", with: ".")
            } else {
                // E.g. 1,610.00 (US style) -> Remove comma, keep dot
                cleaned = cleaned.replacingOccurrences(of: ",", with: "")
            }
        } else if cleaned.contains(",") {
            // E.g. "250,00" -> "250.00"
            cleaned = cleaned.replacingOccurrences(of: ",", with: ".")
        }
        
        // Finally, convert to Double
        return Double(cleaned)
    }
}
