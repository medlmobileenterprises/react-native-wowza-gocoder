
# react-native-wowza-gocoder

## About
This is a Native Module for React Native that allows integration of Wowza's GoCoder SDK in less time.  It has been battle tested on our internal and client projects.  !Note* we require RN 0.42+ for this to work!  

## Getting started

`$ npm install react-native-wowza-gocoder --save`

### Mostly automatic installation

`$ react-native link react-native-wowza-gocoder`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-wowza-gocoder` and add `RNWowzaBroadcaster.xcodeproj`
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
  	include ':react-native-wowza-gocoder'
  	project(':react-native-wowza-gocoder').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-wowza-gocoder/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-wowza-gocoder')
  	```

##### Post installation Android
1. After obtaining WowzaGoCoderSDK aar file, add it to your nodemodules/react-native-wowza-gocoder to the libs directory(create it if needed)
2. http://www.wowza.com/resources/gocodersdk/docs/1.0/intro-installation/

## Usage
```javascript

1. Import the module
`import BroadcastView from 'react-native-wowza-gocoder';`
2. Set a config
  `const config ={
    hostAddress:'',
    applicationName:'',
    username:'',
    password:'',
    streamName:'',
    sdkLicenseKey:''
  };`
3. Add functions for debug, testing
  `onBroadcastStart(){
    console.log("Bcast start");
  }
  onBroadcastFail(){
    console.log("Bcast fail");
  }
  onBroadcastStatusChange(){
    console.log("Bcast status change");
  }
  onBroadcastEventReceive(){
    console.log("Bcast event receive");
  }
  onBroadcastErrorReceive(){
    console.log("Bcast error receive");
  }
  onBroadcastVideoEncoded(){
    console.log("Bcast encoded");
  }
  onBroadcastStop(){
    console.log("Bcast stop");
  }`
4. Use the component in render
`<BroadcastView style= {styles.videoContainer}
                     hostAddress = {config.hostAddress}
                     applicationName = {config.applicationName}
                     streamName = {config.streamName}
                     broadcasting = {false}
                     username = {config.username}
                     password = {config.password}
                     sizePreset = {3}
                     port={1935}
                     muted = {false}
                     flashOn = {false}
                     frontCamera =  {false}
                     onBroadcastStart= {this.onBroadcastStart}
                     onBroadcastFail= {this.onBroadcastFail}
                     onBroadcastStatusChange= {this.onBroadcastStatusChange}
                     onBroadcastEventReceive= {this.onBroadcastEventReceive}
                     onBroadcastErrorReceive= {this.onBroadcastErrorReceive}
                     onBroadcastVideoEncoded = {this.onBroadcastVideoEncoded}
                     onBroadcastStop = {this.onBroadcastStop}
                     sdkLicenseKey={config.sdkLicenseKey}
      >
  </BroadcastView>`
5. Be sure to use absolute positioning on your styles otherwise the video may not show correctly
  `const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  videoContainer:{
    position:'absolute',
    top:0,
    left:0,
    right:0,
    bottom:40
  }
  });`

  //Using the broadcast module
  var BroadcastManager =  NativeModules.BroadcastModule;

  BroadcastManager.startTimer(1, 3600);// Android only - first argument - timer interval, second argument time to timeout timer in seconds


 //Stop Timer when stopping the broacast - Android only       
  BroadcastManager.stopTimer();
```
## TODOS

- [ ] Add better support for the size preset props for both platforms
- [ ] Add a config for the different keys provided per platform
