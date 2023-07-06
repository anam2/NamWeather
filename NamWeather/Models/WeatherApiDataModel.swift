import Foundation

struct WeatherApiDataModel: Codable {
    var latitude: Decimal = 0.0
    var longitude: Decimal = 0.0
    var timeZone: String = ""
    var elevation: Double = 0.0
    var currentWeather: Weather = Weather()
    var dailyWeather: DailyWeather = DailyWeather()
    var hourlyWeather: HourlyWeather = HourlyWeather()

    private enum CodingKeys: String, CodingKey {
        case latitude, longitude, elevation
        case timeZone = "timezone"
        case currentWeather = "current_weather"
        case dailyWeather = "daily"
        case hourlyWeather = "hourly"
    }

    func getCurrentLocation() -> Location {
        return Location(latitude: latitude,
                        longitude: longitude,
                        timeZone: timeZone,
                        elevation: elevation)
    }
}
