# Russmedia Tee iOS
iOS SDK for Russmedia Engagement Engine

### Make it run

First thing is, to import the framework.

```swift
import TeeSDK
```

### Enabling the debug mode

Debug mode is needs to enabled by setting static property before first call of `TEE.instance`. Debug mode enables UISwitch in left bottom corner of the screen, which opens console with all TEE traffic. Console screens also offers the button to switch socket endpoints, if some debug endpoints are provided in Info.plist. See Info.plist requitrements lower. Default value is `false`

```swift
TEE.IS_DEV = true
```

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

Whenever you determinate, that user is not anonymous anymore, you call init method again, with user identificator as parameter.

```swift
TEE.instance.initConnection(userID: "bruce.wayne@gothamail.com")
```

Logout method will cancle session with given user and will get anonymous token to starts with points from 0.

```swift
TEE.instance.logout()
```

### Attaching and fireing challanges in code

To enable challenges for each part of app, you call register method for every screen, that should hold elements to trigger challenges.
Each View is registrered for own challanges under unique string `detailPageId` and provides reference to root UIView of the screen.

```swift
TEE.instance.registerChallengesFor(detailPageId: "uniqueID", view: self.view)
```

Than, particular challenges can be triggered by hand, using ID of element, with call:

```swift
TEE.instance.fireChallenge(withElementId: ".article-detail.selected .share.facebook")
```

### Attaching and fireing via IB

 You can attach challenge code as `accessibilityIdentifier` to an UIButton or `TEEUIScrollViewObservable`*, so when registering detil page with `registerChallengesFor(detailPageId:, view:)`, challenge will be attached, and fired automatically when interacting with the element.

* for triggering scroll challenge, this ScrollView class is needed
```swift
@IBOutlet weak var scrollView: TEEUIScrollViewObservable!
```

### User activity indication

Engagement Engine measures also user activity in general. The best to set `activityPing()` call is UIApplicationDelegate methods.

```swift
func applicationDidEnterBackground(_ application: UIApplication) {
 TEE.instance.activityPing()
}

func applicationDidBecomeActive(_ application: UIApplication) {
 TEE.instance.activityPing()
}
```

### Sample usage

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?


 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

  TEE.IS_DEV = true
	

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
 @IBOutlet weak var content: UILabel!
	
 var pageKey: "productNr123"
	
 override func viewDidLoad() {
  super.viewDidLoad()
		
  // Asociating scrollview with expecting challenge code
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
