# 0.7.2
- Built with Xcode 15.3, tested on iOS 17.
- Adds NSPrivacyCollectedDataTypes to Apple's PrivacyInfo, in order to let apps using the SDK pass Xcode privacy reports. Note that actually this should not have been required as the SDK meets the criteria that [Apple states in "... data that may not need to be disclosed include data collected in optional feedback forms ..."](https://developer.apple.com/app-store/app-privacy-details/#optional-disclosure). The collected data types that leave the device are: 
	- “Other user content” (for all data that a user submits in a form), 
	- “Photos or videos” (the user can submit a screenshot), 
	- “Other diagnostic data” (system version and sdk version for support)

# 0.7.1
- Built with Xcode 15.3, tested on iOS 17.
- The SDK declares Apple's NSPrivacyAccessedAPITypeReasons for using the UserDefaults API. Our SDK only accesses the data that it has written itself to the UserDefaults. It uses it to store limited functional state, in order to prevent showing a form that the user has already seen.

# 0.7.0
- Built with Xcode 15.2, tested on iOS 17.
- Minimum iOS version raised to 12.
- Reworked deployment condition logic: Now passive triggers will respect all deployment conditions. Passive triggers ignore the session ("Refresh condition settings per visitor after {x} days"), except for when the condition `"Show only to a percentage of users"` is set. Previously, passive triggers in the sdk always ignored session and all deployment conditions.
- Identifies itself in the feedback inbox as "MopinionSDK iOS-web 0.7.0".
- Reworked log messages on deployment conditions.
- Removed double space from the log messages.
- the `onCallbackEventError` closure can now also return `NO_FORM_WILL_OPEN` in its mopinionEvent argument.

# 0.6.1
- Built with Xcode 15.0, tested on iOS 16.
- Deprecate method `openFormAlways(:)` in favour of new method `openFormAlways(:formKey:forEvent)`.
- solves a bug in mopinion-sdk-ios-web 0.6.0 where the FORM\_CLOSED, FORM\_OPEN, FORM\_SENT callbacks from opened forms might not arrive at the caller.

# 0.6.0
- Built with Xcode 14.3.1, tested on iOS 16.
- Minimum iOS version raised to 11.
- Calls to the evaluate(), event(), load() and openFormAlways() methods now execute in serial order.
- Introduces new state `NO_FORM_WILL_OPEN` for callbacks.

# 0.5.2
- Rebuilt with Xcode 14.1, tested on iOS 16.
- Dropped 32-bit support.
- CocoaPods minimum iOS version raised to 11.
- Brought forward the insertion of extra/meta data in the webform.
- Downloaded deployments are cached and only reloaded after least 30 minutes.

# 0.5.1
- Fixed an issue with iOS 15 where the extra/meta data and screenshot could disappear.

# 0.5.0
- SDK framework format converted to xcframework. 
- Support for Swift Package Manager 5.3, in github release 0.5.0-swiftpm.
- Support for iOS Simulator on ARM Macs.
- Introduced `MopinionCallbackEvents` for when a form is displayed, the user has submitted a form or when a form closed.

# 0.4.6
- New method `evaluate()` and its asynchronous callback response `mopinionOnEvaluateHandler()` as part of the protocol `MopinionOnEvaluateDelegate` to verify whether or not a form would be opened for a specified event. 
- New method `openFormAlways()`, to be used with the `mopinionOnEvaluateHandler()` method, to open a form regardless of any proactive conditions in the deployment.

# 0.4.5
- Removed deprecated UIWebView dependencies.

# 0.4.4
- Xcode 11.4 / Xcode 12 support.

# 0.4.3
- Autoclose of webforms.
- Allow weblinks to open browser.
- New trigger rule: submit-rule. Allows opening a proactive form until it has been submitted at least once.

# 0.4.2
- rebuilt with Xcode 11.2.1

# 0.4.1
- Swift 5.1.2 support.

# 0.4.0
- Swift 5.1/Xcode 11/iOS 13 support.

# 0.3.5
- Same as 0.4.0 but built for Swift 5.0/Xcode 10.3.

# 0.3.4
- New method `removeData()` to remove all or a single key-value pair from the extra data previously supplied with the data(key,value) method.
- Autolayout-fix for iOS11+.

# 0.3.3
- dismiss only localViewController.

# 0.3.1 
- New method `data()` to send extra data from the app to your form.