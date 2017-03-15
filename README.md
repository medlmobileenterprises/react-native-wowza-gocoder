
# react-native-wowza-gocoder

## Getting started

`$ npm install react-native-wowza-gocoder --save`

### Mostly automatic installation

`$ react-native link react-native-wowza-gocoder`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-wowza-broadcaster` and add `RNWowzaBroadcaster.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNWowzaBroadcaster.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

##### Post installation iOS
1. After obtaining WowzaGoCoderSDK framework and the wowzastatic-lib, add them both to a folder in the root directory of the project. 
2. Add the WowzaGoCoderSDK.framework to the build phases for your app target, add a copy files phase with the WowzaGoCoder.SDK http://www.wowza.com/resources/gocodersdk/docs/1.0/intro-installation/

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.rngocoder.RNWowzaBroadcasterPackage;` to the imports at the top of the file
  - Add `new RNWowzaBroadcasterPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-wowza-broadcaster'
  	project(':react-native-wowza-broadcaster').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-wowza-broadcaster/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-wowza-broadcaster')
  	```
    
##### Post installation Android
1. After obtaining WowzaGoCoderSDK aar file, add it to your nodemodules/react-native-wowza-gocoder to the libs directory(create it if needed) 
2. http://www.wowza.com/resources/gocodersdk/docs/1.0/intro-installation/

## Usage
```javascript
import BroadcastView from 'react-native-wowza-broadcaster';

  <BroadcastView style= {yourStyle}
                 hostAddress = {hostaddress}
                 applicationName = {applicationName}
                 streamName = {streamName}
                 broadcasting = {false} //change this value to start broadcast
                 username = {username}
                 password = {password}
                 sizePreset = {3}
                 port={}//default is 1935
                 muted = {false}
                 flashOn = {false}
                 frontCamera =  {false}
                 onBroadcastStart= {}
                 onBroadcastFail= {}
                 onBroadcastStatusChange= {}
                 onBroadcastEventReceive= {}
                 onBroadcastErrorReceive= {}
                 onBroadcastVideoEncoded = {/*ios only use this to get recording time*/}
                 onBroadcastStop = {}
                 >
  </BroadcastView>
  ;
  
  //Using the broadcast module
  var BroadcastManager =  NativeModules.BroadcastModule;
  
  BroadcastManager.startTimer(1, 3600);// Android only - first argument - timer interval, second argument time to timeout timer in seconds
  

 //Stop Timer when stopping the broacast - Android only       
  BroadcastManager.stopTimer();
```

## Running the example project
1. Install and link dependencies
```
cd react-native-wowza-gocoder/example
npm install
react-native-link
```
2. Download the SDK - https://www.wowza.com/pricing/installer#gocodersdk-downloads
3. Unzip and add wowzagocoder_static_lib and WowzaGoCoderSDK.framework to /example/ios/
4. Change the project bundle identifier to match the one tied to your GoCoder license key
    * If you don't have a license key you can register for a free trial: https://www.wowza.com/products/gocoder/sdk/trial
5. Configure your license key and server settings in example/index.js

## TODOS

- [ ] Add better support for the size preset props for both platforms
- [ ] Manage Android timer within BroadcastView component


  
