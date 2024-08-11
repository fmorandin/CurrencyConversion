## Currency Conversion

The idea of this small app is to be used to retrieve a list with some Exchange Rate Quotes from an API and also to provide a very basic calculator to convert an amount between
two currencies.

### Technologies
- The app is entirely written in [_Swift_](https://www.swift.org/)
- The UI framework is [_UIKit_](https://developer.apple.com/documentation/uikit)
- And the architecture is [_MVVM_](https://en.wikipedia.org/wiki/Model–view–viewmodel)
- There are not external dependencies
- A very basic and simple cache is being done using [_UserDefaults_](https://developer.apple.com/documentation/foundation/userdefaults)
- Unit tests are created using [_XCTest_](https://developer.apple.com/documentation/xctest) framework
- The data is provided by [Frankfurter](https://www.frankfurter.app)
- The network layer was implemented using [_Combine_](https://developer.apple.com/documentation/combine)

### Current Scope
At this time, the app has two screens:
- A list of the Exchange Rate Quotes having EUR as a base
- A simple calculator to convert data.

The first screen will always be populated calling the [_/latest_](https://www.frankfurter.app/docs/#latest) endpoint.
An improvement that could be done at this point is to add a cache to prevent this API to be called everytime the user opens the page.

The second screen contains a very basic calculator where the user select the "from" currency, the "to" currency, provide the amount to be converted and, once the API returns
the converted value a label is updated with the amount.
This conversion is also done by the API and the endpoint that is being used is [_/latest?amount={amount}&from={from}&to={to}_](https://www.frankfurter.app/docs/)

### Improvement
As a path forward for the app, some improvements could be added such as:
- Use CoreData to save all the conversions done by the user and provide a list with them so the user can check the history
- Allow the user to select the base currency on the first screen so they can have more options when checking the rates
- Add some loadings while the requests are being done
- Add some cache to the Exchange Rate Quotes since that, per the documentation, it is only updated once a day
- Add a search field in the first screen so the user can find the information faster
- Implement some proper error handling
- Adapt the layout for other platforms such as iPadOS
- Update the network layer to use Async/Await

### Side Notes
During the implementation a board in the Apple Reminders was created to track the tasks (the tasks are written in Portuguese) and this is its current state
<img width="881" alt="Captura de ecrã 2024-08-11, às 17 35 52" src="https://github.com/user-attachments/assets/9aaae8f1-2f78-4088-afcb-90a142773114">
