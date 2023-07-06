struct Weather: Codable {
    var temp: Double = 0.0
    var windSpeed: Double = 0.0
    var windDirection: Double = 0.0
    var weatherCode: Int = 0
    var time: String = ""

    private enum CodingKeys: String, CodingKey {
        case time
        case temp = "temperature"
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case weatherCode = "weathercode"
    }
}
