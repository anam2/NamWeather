import Foundation

struct Location: Codable {
    var latitude: Decimal = 0.0
    var longitude: Decimal = 0.0
    var timeZone: String = ""
    var elevation: Double = 0.0
}
