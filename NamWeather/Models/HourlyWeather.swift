struct HourlyWeather: Codable {
    var time: [String] = []
    var hourlyTemperature: [Double] = []
    var weatherCodes: [Int] = []

    private enum CodingKeys: String, CodingKey {
        case time
        case hourlyTemperature = "apparent_temperature"
        case weatherCodes = "weathercode"
    }
}
