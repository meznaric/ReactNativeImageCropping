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
import {
  NativeModules,
} from 'react-native'
const { ReactNativeImageCropping } = NativeModules;
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
    })
    .catch(err => { console.log(err) })
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
const aspectRatio = ReactNativeImageCropping.AspectRatioSquare;

ReactNativeImageCropping
    .cropImageWithUrlAndAspect(imageUrl, aspectRatio)
    .then(image => {
        //Image is saved in NSTemporaryDirectory!
        //image = {uri, width, height}  
    })
    .catch(err => { console.log(err) })
```


