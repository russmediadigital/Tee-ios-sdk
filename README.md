# Russmedia Tee iOS
iOS SDK for Russmedia Engagement Engine v 1.0.10

### Requirements

iOS Deployment Target 9.0

### Take it on board

#### Cocoapods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/). Than use following spec.

```ruby
pod 'TeeSDK', :git => 'https://github.com/russmedia/Tee-ios-sdk.git', :branch => 'master'
```

#### Embedded

Or use downloaded framework as embedded binary for your project.

![embedded](https://github.com/russmedia/Tee-ios-sdk/blob/master/readme_img/embedded.jpg)

### Make it run

First thing is, to import the framework.

```swift
import TeeSDK
```
<!---->
<!--### Enabling the debug mode-->
<!---->
<!--Debug mode needs to be enabled by setting static property before first call of `TEE.instance` is made. Debug mode enables UISwitch in left bottom corner of the screen, which opens console with all TEE traffic. Console screens also offers the button to switch socket endpoints. When endpoint is changed, app restart is needed. Endpoint is changeable just when any debug endpoints are provided in Info.plist. See Info.plist requirements lower. Default value is `false`-->
<!---->
<!--```swift-->
<!--TEE.IS_DEV = true-->
<!--```-->

Once imported, you can access singleton instance of the framework and implement some delegates methods and properties.

### onCall

Called, on every request, that is made by framework.

```swift
TEE.instance.onCall = { callName in
 print("Tee is making call")
}
```

### onMessageReceived

Called, when any message arrives. `onCall` and `onMessageReceived` may be a good place to paste own tracking of engine.

```swift
TEE.instance.onMessageReceived = { message in
 print("Tee is getting message")
}
```

### executeAfterInitialized

Method, that enques blocks, which are fired since TEE has initialised. Typically, wait with execution of relevant deeplinks, until any collector token is already received.

```swift
TEE.instance.executeAfterInitialized {
 print("Anonymous or logged-in user is active")
}
```

### executeAfterNotAnonymous

Method takes block, that is executed right when TEE has known, logged-in user. And as second parameter, takes expiration of block, that can invalidate execution after some time. Typically, since user is logged in, you may want to adapt his app UI.

```swift
TEE.instance.executeAfterNotAnonymous {
 print("User is finally logged in")
}
```

### handlePushRegistration

You may want to notify users, with targeting based on TEE profile. You can associate push notification token with specific user.

```swift
func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
 TEE.instance.handlePushRegistration(deviceToken: deviceToken)
}
```

### isAnonymous

Readonly Bool for getting info, if currently running session is anonymous, or with logged-in user.

```swift
TEE.instance.isAnonymous
```

### verbosePrint

Talky log of communication with socket server in console. Default value is `false`

```swift
TEE.instance.verbosePrint = true
```

### presentingViewController

UIViewController, that is used for presenting overlayed modal views, for engagement engine notifications. You can disable notification by keeping this property unset.

```swift
TEE.instance.presentingViewController = window?.rootViewController
```

### Connection to server

Since all props and delegates are set, you can enable connection itself with tracking of anonymous user.
Activity will be tracked and saved under new generic collector token.

```swift
TEE.instance.initConnection()
```

Whenever you determinate, that user is not anonymous anymore, you call init method again, with remoteId and userName as parameters. RemoteId should represent unique identificator of the user and userName, as optional parameter, as human readable string as display name.

```swift
TEE.instance.initConnection(remoteId: "bruce.wayne@gothamail.com", userName: "BMan")
```

Logout method will cancel session with given user and will get anonymous token to starts with points from 0.

```swift
TEE.instance.logout()
```

### Attaching and firing challanges in code

To enable challenges for each part of app, you call register method for every screen, that should hold elements to trigger challenges.
Each View is registrered for own challanges under unique string `detailPageId` and provides reference to root UIView of the screen.

```swift
TEE.instance.registerChallengesFor(detailPageId: "uniqueViewID", view: self.view)
```

Than, particular challenges can be triggered in code, using ID of challenge, with call:

```swift
TEE.instance.fireChallenge(withElementId: ".article-detail.selected .share.facebook")
```

### Attaching and firing via IB

You can set ID of challenge as `accessibilityIdentifier` of an `UIButton` or `TEEUIScrollViewObservable`. Than, when you register detail page with `registerChallengesFor(detailPageId:, view:)`, challenges will be attached, and fired automatically when interacting with the element.

For triggering scroll challenge, TEEUIScrollViewObservable subclass is required
```swift
@IBOutlet weak var scrollView: TEEUIScrollViewObservable!
```

### Detach challenges from view 

```swift
TEE.instance.resignViewForChallenges(withKey: "uniqueViewID")
```

### User activity indication

Engagement Engine measures also user activity in general. The best place to run `activityPing()` call is UIApplicationDelegate methods.

```swift
func applicationDidEnterBackground(_ application: UIApplication) {
 TEE.instance.activityPing()
}

func applicationDidBecomeActive(_ application: UIApplication) {
 TEE.instance.activityPing()
}
```

### Switch the language

You can call method `updateLanguage(lang: String)` on running session, to switch language of TEE UI for currently active collector token. Either anonymous or already paired one with user.  As a parameter, is expected Alpha-2 language code, ISO 639-1.

```swift
TEE.instance.updateLanguage(lang: "de")
```

### Format number of points in TEEPointsView

Use method `setPointsFormatter(_ formatter: NumberFormatter)` to pass number formatter, that is applied to every TEEPointsView in app while displaying current points.

```swift
let formatter = NumberFormatter()
formatter.groupingSeparator = "."
formatter.numberStyle = .decimal

TEE.instance.setPointsFormatter(formatter)
```

### Info.plist requirements and optional properties

Engagement Engine is looking for two mandatory strings under `TEE` dictionary, that shoud be provided in `Info.plist`. TEE/ApiToken and TEE/liveSocketEndpoint

- TEE (Dictionary)
  - ApiToken (String)
  - liveSocketEndpoint (String)
  - devSocketEndpoint1 (String) // optional socket endpoint, selectable in debug console
  - devSocketEndpointXY (String) // optional socket endpoint, selectable in debug console
  - themeColorHex (String) // optional

### Sample implementation

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?


 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

  TEE.instance.onCall = { callName in
   print("Tee is making call")
  }

  TEE.instance.onMessageReceived = { message in
   print("Tee is getting message")
  }
	
  TEE.instance.verbosePrint = true
  TEE.instance.initConnection() // Anonymous init
  TEE.instance.presentingViewController = window?.rootViewController

  return true
 }

 func applicationDidEnterBackground(_ application: UIApplication) {
  TEE.instance.activityPing()
 }

 func applicationDidBecomeActive(_ application: UIApplication) {
  TEE.instance.activityPing()
 }
}
```

```swift
import UIKit
import TeeSDK

class DetailViewController: UIViewController {

 @IBOutlet weak var scrollView: TEEUIScrollViewObservable!
	
 let pageKey: "productDetail123"
	
 override func viewDidLoad() {
  super.viewDidLoad()
		
  // Associating scrollview with expected challenge code
  scrollView.accessibilityIdentifier = ".article-detail.selected .article.scroll"
		
  TEE.instance.registerChallengesFor(detailPageId: pageKey, view: self.view)
 }
	
 @IBAction func FBShareAction(_ sender: Any) {
  TEE.instance.fireChallenge(withElementId: ".article-detail.selected .share.facebook")
 }
	
 deinit {
  TEE.instance.resignViewForChallenges(withKey: pageKey)
 }
}
```
