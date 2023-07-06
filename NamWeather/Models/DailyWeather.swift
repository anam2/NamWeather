struct DailyWeather: Codable {
    var time: [String] = []
    var maxTemperatures: [Double] = []
    var minTemperatures: [Double] = []
    var weatherCodes: [Int] = []

    private enum CodingKeys: String, CodingKey {
        case time
        case maxTemperatures = "apparent_temperature_max"
        case minTemperatures = "apparent_temperature_min"
        case weatherCodes = "weathercode"
    }
}
