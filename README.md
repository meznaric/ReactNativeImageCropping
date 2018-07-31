Simple react-native image cropping library wrapper around [siong1987/TOCropViewController](https://github.com/siong1987/TOCropViewController)

![TOCropViewController](https://raw.githubusercontent.com/siong1987/TOCropViewController/master/screenshot.jpg)

## Installation

Supported only on iOS.

### Add it to your project

1. `npm install react-native-image-cropping --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-image-cropping` and add `ReactNativeImageCropping.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `libReactNativeImageCropping.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `ReactNativeImageCropping.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../react-native/React` and `$(SRCROOT)/../../React` - mark both as `recursive`.
5. Re-run your project (`Cmd+R`)

### Setup trouble?

If you get stuck open an issue. It's the first time I've published react native package and I may have not provided all necessary information.

## Usage

### Import module

```javascript
const React = require('react-native');
const {ReactNativeImageCropping} = React.NativeModules;
```

### Crop the image

It is using RCTImageLoader so it should be able to crop any image that react knows how to load / display.

#### Without aspect ratio restriction:

```javascript
const originalImage = require('CrazyFlowers.jpg');

ReactNativeImageCropping
	.cropImageWithUrl(originalImage.uri)
    .then(image => {
		//Image is saved in NSTemporaryDirectory!
		//image = {uri, width, height}	
	},
	err => console.log(b));
```

#### Lock to specific aspect ratio:

Available aspect ratios:
```javascript
 - AspectRatioOriginal
 - AspectRatioSquare
 - AspectRatio3x2
 - AspectRatio5x4
 - AspectRatio4x3
 - AspectRatio5x4
 - AspectRatio7x5
 - AspectRatio16x9
```

Example:

```javascript
let aspectRatio = ReactNativeImageCropping.AspectRatioSquare;

ReactNativeImageCropping
    .cropImageWithUrlAndAspect(imageUrl, aspectRatio)
    .then(image => {
        //Image is saved in NSTemporaryDirectory!
        //image = {uri, width, height}  
    },
    err => console.log(b));
```

#### Handling issue with control center
When you have a large image, the top of the cropping region will trigger control center when you try to crop. To avoid this, set `View controller-based status bar appearance` in the `info.plist` to `YES`. Then, in the `AppDelegate.m`, change it to be: 

```swift
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [application setStatusBarHidden:YES]; //this restricts control center access throughout your app - users can still access it, but not as easily. 
 ...
```

