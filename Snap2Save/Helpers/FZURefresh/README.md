# FZURefresh

A pull to refresh or load more extension used on UIScrollView implement by swift.

## Requirements
- iOS 8.0+
- Swift 3.0
- Xcode 8.0

## Installation

FZURefresh is available through [CocoaPods](http://cocoapods.org).

```ruby
pod "FZURefresh"
```

## Screenshot
![FZURefresh](Screenshot.gif)

## Usage

FZURefresh work any view based on the UIScrollView.

UITableView
```swift
tableView.toRefresh() {

}
tableView.toLoadMore(){
    
}
```

UIWebView
```swift
webView.scrollView.toRefresh() {

}
webView.scrollView.toLoadMore(){

}
```

UICollectionView
```swift
collectionView.toRefresh() {

}
collectionView.toLoadMore(){

}
```

## License

FZURefresh is available under the MIT license. See the LICENSE file for more info.
