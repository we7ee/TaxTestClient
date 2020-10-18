# Tax Test Client

## Summery

This is a small test client application that communicates with the `https://steuerwebprelive.buhl.de/demoservice/rest` API.

### Technical overview
#### Architecture
The chosen architecture is MVC+C with UIKit and Storyboard. The views are seperated in `Scene`s. Each `Scene` consists of at least one `UIViewController`, a `Storyboad` and a `Controller`. The `Controller` can have multiple `Controller`s.

#### Network layer
The network layer consists of a `NetworkManager` and works with `EndPoint`s. Each API call has its own `EndPoint` struct that contains all relevant information needed to create a `URLRequest`.

## Credits
Willy Breitenbach

## License
For private use only. Copyright by Willy Breitenbach