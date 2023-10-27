# WeatherApp
Simple weather app


Generic notes:

1. WeatherApp is simple two screens app that takes advantage of https://openweathermap.org/current, https://openweathermap.org/api/geocoding-api to present temperature for either current location or geolocated user's selection location.
2. The prime architecture is based on MVVM, however the exact implementation details are my ideas. Neither solution nor the idea was copied from anywhere. 
3. Application uses async/await APIs, actors and SWIFTUI, which both were somehow chalenging to introduce into MVVM concepts. I would say it worked pretty well, however, there are plenty of ideas/ways how to improve.
4. Unit tests are written for logic / view models. The coverage of these however is not 100%. It felt like adding more of similar code has no more added value to this, interview task.
5. Developed with Xcode 14.3.1 with "Complete" set on "Strict Conccurency Checking". Deployment target iOS 16.0. SwiftGen was used to generate variables for localizable strings.

Requirements comments:

"App has to contain exactly two screens" - It does, however there is alert to enter open weather API key. For security reason it simply cannot be placed in code.

"The first screen (...)" - It is fulfilled, however app does not store selected location. It was not specifically said, so I did not bother.

"The second screen (...)" - The search is there, works as expected. There is some visual glitch, that on 2nd entry, location picker view  search bar "blinks" for some reason. Interesting one, seems like some SwiftUI specific thing, I was not able to debug it quickly enough, so I decided to abandon it for now as not key detail.

"The app has (...)" - networks errors are handled, data is refreshed every 1 minute, unless unit is changed (system settings - measurement system), user's location changes or user selects location. Manual selecting location stops location manager.

"For implementation (...)" - I did some choices as specified in point 2. It does not mean that I would do the same ones for any other project. This was just suiting this task.

"Ensure you write (...)" - I did. Views could be obviously tested with snapshots. Some factories cannot be mocked, but it is a detail.

"Following SOLID princples (...)" - well, I think, I did.

"README (...)" - here we are.

"Test coverage" - as said above, it's not full on "testable" elements as it would just repeat similar concept on similar use cases, so I decided not to, but there are sync / async, viewModels and services tests. (TO DO: LocationPickerViewModel, fetchGeo method from WeatherService, KeychainService and some utils computed properties elsewhere)

"Dark/Light (...)" - it mostly works by default.

"Forecase react (...)" - it does, it also reacts on measurement change in system settings (uk, metric, us choice).

"Supporting multiple (...)" - like said above, unit changes accordingly. 

I've tested manually on iPhone 14 Pro, iOS 16.6.1.