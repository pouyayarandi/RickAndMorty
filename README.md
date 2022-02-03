# Rick and Morty app

This project is a sample app for evaluation. In this document you can find the below parts

- [Architecture](#architecture)
- [Pagination](#pagination)
- [IoC Container](#ioc-container)
- [Coordinators](#coordinators)
- [Tests](#tests)
- [To Do](#to-do)

## Architecture

In this project, I have used Clean architecture with the MVVM architectural design pattern. According to the definition of [Uncle Bob's Clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), We have these layers in our project:
- Core (aka Entities): This layer is the lowest one and contains core services (network, etc.), models and interfaces of the higher level (Repositories).
- Repositories: This layer contains classes that should handle the fetching of data (in our case, it just downloads from the internet, and there is no local database)
- View Models: In this layer, repositories will be used to handle the logic of every single page in our app. I used Combine for this layer as the binding solution.
- View Controllers: The highest level layer is `ViewController`. This layer will bind the data of the previous layer and will be updated with the changes of the observing data.

In this architecture, layers just can be depend on their lower layers and are not able to have any dependency to the upper ones, which makes our code more reusable and less coupled.

## Pagination

In both two lists we have in this app, we needed lists to paginate. For this purpose, our repositiories had to have desired methods for pagination. As it was a common behavior and there was a normal structure for that among APIs, I decided to define it as a protocol.

```swift
protocol ListRepositoryProtocol: AnyObject {
    associatedtype Response: PageResponse
    
    var network: NetworkProtocol { get }
    var lastPageInfo: PageData? { get set }
    
    var firstPageRequest: NetworkRequestModel { get }
    var nextPageRequest: NetworkRequestModel? { get }
}

extension ListRepositoryProtocol {
    func getFirstPage(completionHandler: CompletionHandler<Result<Response, NetworkError>>?) { ... }
    func getNextPage(completionHandler: CompletionHandler<Result<Response, NetworkError>>?) { ... }
}
```

This protocol defines the common behavior of paginating services by an extension. For a better vision you can check `CharacterRepository` and `LocationRepository` as examples of comformance to this protocol. The rest of the things about pagination have been handled in the view controllers and the view models.

## IoC Container

I used Swinject as IoC container in this project. What made me to use it was that if we had lots of dependencies, we needed to inject each one in an initializer, which would make our `init()` functions bigger and bigger. But with the power of containers, we can pass a container and then, the entity will resolve the needed dependencies from it.

## Coordinators

The coordinator pattern has been used for handling the navigations. Although this app has just two pages, but the navigations can getting more complex through the growth of the app. So choosing this approach can help us with development in a more scalable way. Currently, we have three coordinators, one for the first tab, one for the second one and a root coordinator (you can find it as `AppCoordinator`). Each coordinator passes the containers to the sub coordinators and in the `init` of them, needed dependencies will be initialized. We could pass containers even for another level to the view models, but at this time I think has no point for us.

## Tests

Some test cases has been written for this project. Through this test cases, some parts of app (e.g. network layer, repositories, view models, etc.) has been tested. The coverage of the app is 56% at the moment and is able to increase because tests are just related to the `Characters` tab and the `Location` has no test. For `CharacterListViewController`, I used snapshot testing, which compares the view with a stored snapshot in both of light and dark appearance. Also in all of test cases I tried to mock the external data to reduce the effect of the other services on the tests as much as possible.

## To Do

Although I tried to do my best for this project, because of the shortage of time some tasks could be done but at the moment it's not possible. Some of these tasks are:

- Add some `UITest` cases: We can add some UITest as E2E or integrated tests in the future.
- More powerful coordinators: At the moment our coordinators are very basic, but with new requirements they can get developed.
