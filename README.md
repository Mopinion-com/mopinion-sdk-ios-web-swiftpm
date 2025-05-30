# Mopinion Mobile web SDK iOS

Use the Mopinion Mobile SDK to collect feedback from iOS apps based on events.
Include the SDK as a Framework in your Xcode project to use Mopinion mobile web feedback forms in your app.

Other Mopinion SDK's are also available:

- [iOS SDK](https://github.com/Mopinion-com/mopinion-sdk-ios)
- [Android SDKs](https://github.com/Mopinion-com/mopinion-sdk-android)

### Contents

- Release notes
- [1. Installation](#install)
 - [1.1 Install using Swift PM](#install-spm)
 - [1.2 Install using CocoaPods](#install-cocoapods)
- [2. Implement the SDK](#implement)
 - [2.1 Display a form](#display)
 - [2.2 Submit extra data](#extra-data)
 - [2.3 Evaluate if a form will open](#evaluate-conditions)
 - [2.4 Using callback mode](#callback-mode)
- [3. Edit triggers](#edit-triggers)

## Release notes for version 0.7.4

### Changes in 0.7.4
- Corrected wrong 0% log message `"random: percentage value of 0 will never trigger form or set session... "` to `"random: percentage value of 0 will never trigger form."`.
- Fixed a retain cycle issue with the delegate or calling uiviewcontroller.
- Fixed the deployment condition "Show only on specific OS (and OS version)" to also work for  multiple versions specified with leading/trailing spaces.

### Remarks
- This readme applies to both the CocoaPods and Swift Package Manager distribution, as the latter uses the same binaries as the GitHub release for CocoaPods. 
- Our Swift Package Manager distribution has changed location starting from version 0.7.3. So if you installed an earlier version of our package, you should delete it from your project.
- Built with Xcode 16.2 and tested on iOS 18.3.1, CocoaPods 1.16.2.

<br>

## <a name="install">1. Installation</a>

The Mopinion Mobile SDK Framework can be installed via either the Swift Package Manager or the popular dependency manager [Cocoapods](https://cocoapods.org).

### <a name="install-spm">1.1 Install using Swift Package Manager in Xcode</a>

1. If you no longer want to use CocoaPods for your project, then in terminal, in the root folder of your project execute: <br>
`pod deintegrate`

2. Open your project's `<your-project-name>.xcodeproj` file in Xcode.
3. If you had version `0.7.2-swiftpm` or older of our package installed, delete it: From your project, under Package Depencies, remove the package "mopinion-sdk-ios-web".
3. In Xcode 16, from the menu, select `File -> Add Package Dependencies…`.  
The Swift Package Collections panel appears. 
4. In the search field of the panel, enter `https://github.com/Mopinion-com/mopinion-sdk-ios-web-swiftpm` and press enter.
5. From the drop-down button `Dependency Rule`, choose one of the following options:
	- `Exact Version` and in the version field enter `0.7.4`.
	- `Up to Next Major Version` and in the version field enter `0.7.4`.
6. Click the button `Add Package`. A package product selection panel appears.
7. Choose `MopinionSDKWeb` and click the button `Add Package`. 

#### SwiftPM bug: invalid archive returned
If at this point you get an error `invalid archive returned from https://...` instead, there possibly is a [keychain credentials and SPM conflict/bug](https://github.com/swiftlang/swift-package-manager/issues/6635#issuecomment-1994559692).
<br>To solve it: 

1. try removing the SPM caches:

 ```sh
 $ rm -rf $HOME/Library/Caches/org.swift.swiftpm/
 ```

2. Then try to add the package again in Xcode, and this time Xcode should prompt you to access Keychain.

<br>

### <a name="install-cocoapods">1.2 Install using CocoaPods</a>
Skip this section if you've installed with swiftpm.

1. Install CocoaPods if you didn't do so already. From macOS Monterey 12.1 installation of cocoapods 1.11.2 works out of the box on ARM based Macs:

 ```sh
$ sudo gem install cocoapods
```


2. In the terminal, create a `Podfile` in the folder that contains your Xcode project :

 ```ruby
platform :ios, '12.0'
use_frameworks!
target '<YOUR TARGET>' do
	pod 'MopinionSDKWeb', '>= 0.7.4'
end
```

3. From that folder, install the needed pods:

 ```sh
$ pod install
```

4. After this, going forward you should use the newly created `<your-project-name>.xcworkspace` file to open in Xcode.

<br>

## <a name="implement">2. Implement the SDK</a>

### <a name="display">2.1 The basics to display a form</a>
In your app code, for instance somewhere late in the `AppDelegate.swift` file, put:

```swift
import MopinionSDK
...
// debug mode
MopinionSDK.load("<MOPINION DEPLOYMENT KEY>", true)
// live
MopinionSDK.load("<MOPINION DEPLOYMENT KEY>")
```

Replace the `<MOPINION DEPLOYMENT KEY>` by your specific deployment key. Copy this key using a web browser from your Mopinion account, in side menu `Data collection`, section `Deployments`, via the button with symbol `<>`.

In a UIViewController, for example `ViewController.swift`, put:

```swift
import MopinionSDK
...
MopinionSDK.event(self, "_button")
```
where `"_button"` is the default passive form event.
You can also make custom events and use them in the Mopinion deployment interface.  
In the Mopinion web app you can enable or disable the feedback form when a user of your app executes the event.
The event could be a touch of a button, at the end of a transaction, proactive, etc.

<br>

## <a name="extra-data">2.2 Submitting extra data</a>

Your app can send extra (string based) data to your form. 

### 2.2.1 Use the data() method
SDK version `0.3.1` introduced the `data()` method to supply a key and a value.

The data should be added before the `event()` method is called if you want to include the data in the form that comes up for that event.

```swift
MopinionSDK.data(_ key: String, _ value: String)
```

Example:

```swift
import MopinionSDK
...
MopinionSDK.load("abcd1234")
...
MopinionSDK.data("first name", "Steve")
MopinionSDK.data("last name", "Jobs")
...
MopinionSDK.event(self, "_button")
```

Note: In the set of meta data, the keys are unique. If you re-use a key, the previous value for that key will be overwritten.

### 2.2.2 clear extra data

From version `0.3.4` it's possible to remove all or a single key-value pair from the extra data previously supplied with the `data(key,value)` method.
To remove a single key-value pair use this method:

```swift
MopinionSDK.removeData(forKey: String)
```
Example:

```swift
MopinionSDK.removeData(forKey: "first name")
```

To remove all supplied extra data use this method without arguments, like for example:

```swift
MopinionSDK.removeData()
```

<br>

## <a name="evaluate-conditions">2.3 Evaluate if a form will open</a>
The `event()` method of the SDK autonomously checks deployment conditions and opens a form, or not.

From SDK version `0.4.6` you can use the `evaluate()` and related methods to give your app more control on opening a form for proactive events or take actions when no form would have opened.

It can also be used on passive events, but such forms will always be allowed to open.

### 2.3.1 Procedure overview

1. Call the `evaluate()` method and pass it the delegate object that implements the `MopinionOnEvaluateDelegate` protocol.
2. In your delegate's callback method `mopinionOnEvaluateHandler()`, check the response parameters and retrieve the `formKey` if there is any.
3. Optionally, pass the `formKey` and `event` to the method `openFormAlways()` to open your form directly, ignoring any conditions in the deployment.

### 2.3.2 evaluate() method
Evaluates whether or not a form would have opened for the specified event. If without errors, the delegate object will receive the `mopinionOnEvaluateHandler()` call with the response.

```swift
func evaluate( _ event: String, onEvaluateDelegate: MopinionOnEvaluateDelegate )

```
Parameters:

* `event`: The name of the event as definied in the deployment. For instance "_button".
* `onEvaluateDelegate `: The object implementing the `MopinionOnEvaluateDelegate` protocol to handle the `mopinionOnEvaluateHandler()` callback method.


### 2.3.3 mopinionOnEvaluateHandler() method
Method where the app receives the response of the evaluate call. Defined by the `MopinionOnEvaluateDelegate` protocol. Note that in case of any system errors this may not be called at all.

```swift
func mopinionOnEvaluateHandler(hasResult: Bool, event: String, formKey: String?, response: [String : Any]?)
```
Parameters:

* `hasResult`: if true then the form identified by the formKey would have opened. If false then the form would not have opened and the formKey might be null in case no forms were found associated with the event.
* `event`: the original event name that was passed to the evaluate call to check in the deployment.
* `formKey`: identifying key of the first feedback form found associated with the event and meeting the deployment conditions. Only one formKey will be selected even if multiple forms matched the event name in the deployment.
* `response`: optional dictionary object for extra response details on success/failure and forms. Reserved for future extensions.


### 2.3.4 openFormAlways() method
Opens the form specified by the formkey for the event, regardless of any deployment conditions.

```swift
func openFormAlways(_ parentView: UIViewController, formKey: String, forEvent: event)
```
Parameters:

* `parentView`: Your UIViewController object that can act as a parent view controller for the SDK.
* `formKey`: key of a feedback form as provided by the mopinionOnEvaluateHandler() call.
* `forEvent`: The same event as passed to the `evaluate()` call. For instance "_button".


### 2.3.5 Example of using evaluate()
This snippet of pseudo code highlights the key points on how the aforementioned procedure fits together to implement the `MopinionOnEvaluateDelegate` protocol.

```swift
...
import MopinionSDK
...
// assuming that in your AppDelegate, you already did MopinionSDK.load(<MOPINION DEPLOYMENT KEY>)
...
class ViewController: UIViewController, MopinionOnEvaluateDelegate {
...
    func doSomething() {
        // check if a form would open                       
        MopinionSDK.evaluate("_myproactiveevent", onEvaluateDelegate: self)
        // the actual result will be in the mopinionOnEvaluateHandler call
    }
...
	// callback handler for protocol MopinionOnEvaluateDelegate
    func mopinionOnEvaluateHandler(hasResult: Bool, event: String, formKey: String?, response: [String : Any]?) {
        if(hasResult) {
            // at least one form was found and all optional parameters are non-null
            // because conditions can change every time, use the form key to open it directly
            MopinionSDK.openFormAlways(self, formKey: formKey!, forEvent: event)
        }else{
            if let _ = formKey {
                // Found form wouldn't open for event
                // we'll open it anyway using the formKey and event
                MopinionSDK.openFormAlways(self, formKey: formKey!, forEvent: event)
            }else{
                // no form found for event
                ...
            }
        }
    }
...
```

<br>

## <a name="callback-mode">2.4 Using callback mode</a>
By default the SDK manages the feedback form autonomously without further involving your app. 
SDK version `0.5.0` introduces callbacks to inform your code of certain actions (MopinionCallbackEvent). 

Provide a callback handler to receive a response, containing either data or possible error information. 


### 2.4.1 Procedure overview

1. Call the `event()` method and pass it a callback method that implements the `MopinionCallbackEventDelegate.onMopinionEvent` protocol.
2. In your callback method `onMopinionEvent()`, check the kind of `mopinionEvent` and optionally call `didSucceed()` or `hasErrors()` on the `response` to check for errors.
3. Optionally, call `hasData()` on the `response` object to check if there is data.
4. Depending on the kind of `mopinionEvent`, check for the presence of data specified by a `ResponseDataKey` using the call `hasData(ResponseDataKey)` on the `response`.
5. To get the data, call `getString(ResponseDataKey)` respectively `getJSONObject(ResponseDataKey)` on the `response`, depending on the type of data to retrieve.

You can also provide an optional error-callback handler to `event()` to seperately receive responses with error information. In that case the primary handler only receives responses without errors.

<br>

### 2.4.2 Callback variants of the `event()` method
Triggers an event you defined in your deployment to open a form and receive MopinionCallbackEvent callbacks. If you don't specify a failHandler, the callback handler will also receive error responses.


```swift
func event(parentView: event: onCallbackEvent:  onCallbackEventError:)
func event(parentView: event: onCallbackEventDelegate:)
func event(parentView: event: onCallbackEventDelegate:  onCallbackEventErrorDelegate:)
```

Parameters:

* `parentView`: The UIViewController that serves as parent view of the app.
* `event`: The name of the event as defined in the deployment for the form. For instance "_button".
* `onCallbackEvent`: a closure implementing the `onMopinionEvent()` callback.
* `onCallbackEventError`: a closure implementing the `onMopinionEventError()` callback for MopinionCallbackEvents that resulted in errors.
* `onCallbackEventDelegate`: The object implementing the `MopinionCallbackEventDelegate` protocol to handle the `onMopinionEvent()` callback.
* `onCallbackEventErrorDelegate`: The object implementing the `MopinionCallbackEventErrorDelegate` protocol to handle the `onMopinionEventError()` callback for MopinionCallbackEvents that resulted in errors.

<br>

### 2.4.3 Callback methods `onMopinionEvent()` and `onMopinionEventError()`

These methods you implement in your code to receive MopinionCallbackEvents. They have the same parameters to pass you a response with optional additional information. 
What information is provided depends on the type of `MopinionCallbackEvent` and its origin.

```swift
func onMopinionEvent(mopinionEvent: MopinionCallbackEvent, response: MopinionResponse)
func onMopinionEventError(mopinionEvent: MopinionCallbackEvent, response: MopinionResponse)
```

Parameters:

* `mopinionEvent`: The kind of response event that you receive from the SDK. Currently one of the following:
	* `FORM_OPEN` : when the form is shown
	* `FORM_SENT` : when the user has submitted the form
	* `FORM_CLOSED` : when the form has closed
	* `NO_FORM_WILL_OPEN` : when no form will open. Is not considered an error, unless the event tried to show a form that no longer exists.

* `response`: The MopinionResponse object containing additional information on the MopinionEvent. The response is never `nil`, but use its `hasData()` methods to check if it contains any additional data, or `hasErrors()` for errors.

<br>

### 2.4.4 MopinionResponse object
The data collection present in this object depends on the kind of MopinionCallbackEvent and its origin. The data is a key-value collection. Both data and errors can be missing. The response object contains methods to inspect and retrieve them. 


#### Getting data with `response.get()` and `response.hasData()`
Check with `hasData(key)` first, as the `get<>(key)` methods can return `null`. Pass a standard `ResponseDataKey` to these methods for the data you're interested in.

ResponseDataKey|Method to read it|Description
---|---|---
DATA_JSONOBJECT|.getJSONObject()|dictionary of the 'raw' JSONObject with all available data
FORM_KEY|.getString()|the internal unique identifier for the form
FORM_NAME|.getString()|the name of the form. Distinct from the title of the form.

<br>

#### MopinionCallbackEvents and provided data in `response`
This is the data that can be present for a certain MopinionCallbackEvent:

MopinionCallbackEvent|ResponseDataKeys|Remarks
---|---|---
NO\_FORM\_WILL_OPEN|FORM_KEY|form key is optional
FORM_OPEN|DATA_JSONOBJECT|
&nbsp;|FORM_KEY|
&nbsp;|FORM_NAME|
FORM_SENT|DATA_JSONOBJECT|
&nbsp;|FORM_KEY|
&nbsp;|FORM_NAME|
FORM_CLOSED|DATA_JSONOBJECT|Currently only automatically closed forms provide data 
&nbsp;|FORM_KEY|only when autoclosed
&nbsp;|FORM_NAME|only when autoclosed

The order in which MopinionCallbackEvents occur is:

	1. NO_FORM_WILL_OPEN
        
        - or - 
         
	1. FORM_OPEN
	2. FORM_SENT (only if the user submits a form)
	3. FORM_CLOSED

<br>

#### Reading `response` errors
Call `response.hasErrors()` , followed by `response.getError()` to get the error object.
The `getError()` method might return `nil`.

<br>

### 2.4.5 Callback handler example to run code after send
Pseudo code to show the usage of the `event()` callback with closures and some involved objects to implement running code after send.
You must wait for the form to be closed after send before running any code affecting your own UI.

```swift
...
import MopinionSDK
...
// assuming that in your AppDelegate, you already did MopinionSDK.load(<MOPINION DEPLOYMENT KEY>)
...
class YourViewController: UIViewController, MopinionOnEvaluateDelegate {
...
    var wasFormSent: Bool = false	// track state outside closure
...
    func demonstrateMopinionCallback() {
        self.wasFormSent = false
    
        // open the form associated with the event "_myfeedbackbutton" from the deployment and receive callbacks in the closures        
        MopinionSDK.event(self, "_myfeedbackbutton", onCallbackEvent: {  (mopinionEvent, response) -> (Void) in
            print("callback in success closure")
            if(mopinionEvent == .FORM_SENT) {
                let formKey = response.getString(.FORM_KEY)!
                print("The form with formKey=\(formKey) has been sent, but is still displayed")
                self.wasFormSent = true
            } else if(mopinionEvent == .FORM_CLOSED) {
                if(self.wasFormSent) {
                    let formKey = response.getString(.FORM_KEY) ?? ""
                    print("The form \(formKey) has been sent and closed, now you can run some code.")
                }
            } else if(mopinionEvent == .NO_FORM_WILL_OPEN) {
                print("No form will open for this event.")
            }
        }, onCallbackEventError: { (mopinionEvent, response) -> (Void) in
            if(mopinionEvent == .NO_FORM_WILL_OPEN) {
                print("Form for key does not exist or failed to load.")
            } else {
                let myError = response.getError();
                print("there was an error during callback: \(String(describing: myError))")
            }
        } )
   }
...
}
...
```

<br>

## <a name="edit-triggers">3. Edit triggers</a>

In the deployment editor of the Mopinion web app you can define event names and triggers that will work with the SDK event names that you used in your app.
Login to your Mopinion account and go to Data collection, Deployments to use this functionality.

![Deployment Editor](images/deployment_edit_triggers.png)

The custom defined events can be used in combination with deployment rules/conditions valid per deployed app instance:

* **trigger**: `passive` or `proactive`. A proactive trigger can show its form only once; you can set the refresh duration after which the trigger can fire again. A passive trigger behaves almost the same, but can fire every time as it ignores the refresh duration (except when the percentage condition is set).
* **refresh duration**: the number of days to wait before the trigger can fire again in an app instance, specified by the setting "Refresh condition settings per visitor after {x} days".
* **submit**: allow opening a proactive form until it has been submitted at least once. This affects the trigger rule, to allow opening a form more than once. Support for this appeared in SDK version 0.4.3.
* **percentage**: % of users that should see the form. This setting makes the trigger fire once per refresh duration, even if no form was shown or it is a passive trigger.
* **date**: only show the form on, after or before a specific date or date range.
* **time**: only show the form at, after or before a specific time or time range.
* **target**: only show the form for a specific OS (iOS or Android) and optional list of versions.
