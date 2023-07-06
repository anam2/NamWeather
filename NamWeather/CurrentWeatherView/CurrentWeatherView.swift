import SwiftUI

struct CurrentWeatherView: View {

    @StateObject var viewModel = CurrentWeatherVM()

    var currentWeather: Weather { viewModel.currentWeather }

    var body: some View {
        switch(viewModel.viewState) {
        case .finished:
            ScrollView {
                VStack {
                    Text("\(String(viewModel.cityName))")
                        .font(.system(size: 20, weight: .bold))
                    Text("\(String(currentWeather.temp))°")
                        .font(.system(size: 60))
                    Text("\(WeatherIconHandler().iconDescription(for: viewModel.currentWeather.weatherCode))")
                        .font(.system(size: 16))

                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.getIndiciesForCurrentTime(quantity: 24), id: \.self) { index in
                                VStack {
                                    if viewModel.getIndiciesForCurrentTime(quantity: 24)[0] == index {
                                        Text("Current")
                                    } else {
                                        Text("\(viewModel.convertWeatherDateTimeToDisplayTime(weatherDateTime: viewModel.hourlyWeather.time[index]))")
                                    }
                                    Image(systemName: WeatherIconHandler().iconName(for: viewModel.hourlyWeather.weatherCodes[index]))
                                        .padding(5)
                                    Text("\(Int(viewModel.hourlyWeather.hourlyTemperature[index].rounded()))°")
                                }
                            }
                        }
                    }
                    .padding([.top, .bottom], 40)

                    VStack(spacing: 30) {
                        ForEach(viewModel.dailyWeather.maxTemperatures.indices, id: \.self) { index in
                            HStack() {
                                Text(viewModel.convertStringDateToTextDate(stringDate: viewModel.dailyWeather.time[index]))
                                    .font(.system(size: 14.0, weight: .bold))
                                    .frame(width: 100)
                                    .padding(.trailing, 20)
                                Image(systemName: WeatherIconHandler().iconName(for: viewModel.dailyWeather.weatherCodes[index]))
                                Spacer()
                                Text("\(Int(viewModel.dailyWeather.minTemperatures[index].rounded()))°")
                                    .frame(width: 50)
                                Text("\(Int(viewModel.dailyWeather.maxTemperatures[index].rounded()))°")
                                    .frame(width: 50)
                            }
                        }
                    }.listStyle(PlainListStyle())
                    Spacer()
                }.padding()
            }.onAppear(perform: viewModel.startUpdatingLocation)
        case .loading:
            ProgressView()
        case .error:
            VStack{
                Text("Error")
            }
        }
    }
}
