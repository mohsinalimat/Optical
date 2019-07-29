<img src="https://github.com/GeekTree0101/Optical/blob/master/screenshots/banner.png" />

[![CI Status](https://img.shields.io/travis/Geektree0101/Optical.svg?style=flat)](https://travis-ci.org/Geektree0101/Optical)
[![Version](https://img.shields.io/cocoapods/v/Optical.svg?style=flat)](https://cocoapods.org/pods/Optical)
[![License](https://img.shields.io/cocoapods/l/Optical.svg?style=flat)](https://cocoapods.org/pods/Optical)
[![Platform](https://img.shields.io/cocoapods/p/Optical.svg?style=flat)](https://cocoapods.org/pods/Optical)

## Intro
Optical is a lightweight and predictable state management pattern framework for iOS

<img src="https://github.com/GeekTree0101/Optical/blob/master/screenshots/intro1.png" />

- [X] Find and fix bugs faster and easier.
- [X] Change existing behaviors with confidence.
- [X] Add new features easily.
- [X] **Write shorter** methods with single responsibility.
- [X] Extract business logic from view controllers into **opticle**.
- [X] Build **reusable** components with network services and utilities objects.
- [X] Write factored code from the start.
- [X] Write fast and **maintainable unit tests** with state base.
- [X] Have **confidence in your tests** to catch regression.

## Structures

### Workflow

<img src="https://github.com/GeekTree0101/Optical/blob/master/screenshots/intro2.png" />

- Dispatch: You can request network(backend) service or API and commit response for mutating state
```swift
  var service: NetworkService = .init()

  func dispatch(_ request: Request) {
    // do commit
    service.request(onSuccess: { [weak self] response in
      self?.commit(.success(response))
    })
  }
```
- Mutation: You can mutate currentState with utilities base on **previous state with response** from dispatcher
```swift
  var utility: SomeUtil = .init()

  func mutate(_ state: State, response: Response) {
    var newState = state
    newState.value = utility.makeValue(from: response)
    return newState
  }
```
- Watcher: You can **observe state**  changing from opticle
```swift
let opticle = SomeOpticle()

opticle.watch().render { newState in 
  print(newSate.value)
}

// you can observe state duplicately!
opticle.watch().render({ newState in 
  print("listen one more \(newSate.value)")
})


// you can observe state on other dispatch qos!
opticle.watch().render(on: DispatchQueue.global(.background), { newState in 
  print("background \(newSate.value)")
})
```

### Mutation & Recover

<img src="https://github.com/GeekTree0101/Optical/blob/master/screenshots/intro3.png" />

- Mutation: It will be called by success commit from dispatcher
- Recover: You can recover state base on error. it will be called by error commit from dispatcher

```swift
  func dispatch(_ request: Request) {
    // success
    self.commit(.success)
    
    // error
    self.commit(.failed(error), from: request)
  }
  
  func mutate(_ state: State, response: Response) {
    // .success only
  }
  
  func recover(_ state: State, request: Request, error: Error?) {
    // .failed from request
  }
```

## Installation

Optical is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Optical'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

Optical is available under the MIT license. See the LICENSE file for more info.
