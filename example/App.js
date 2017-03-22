/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Image,
  Dimensions
} from 'react-native';
import BroadcastView from 'react-native-wowza-gocoder';
import config from './wowzaConfig';
const {width, height} = Dimensions.get('window');

export default class App extends Component {
  constructor(props){
    super(props);
    this.state = {
      broadcasting:false,
      muted:false,
      flashEnabled:false,
      frontCamera:false,
      recordingTime: '00:00:00',
      recordButtonImage: require('./assets/Rec.png')
    }
  }
  render() {
    return (
      <View style={styles.container}>
        <BroadcastView style={styles.contentArea}
                       hostAddress={config.hostAddress}
                       applicationName={config.applicationName}
                       sdkLicenseKey={config.sdkLicenseKey}
                       broadcastName={'BROADCAST_NAME'}
                       username={config.username}
                       password={config.password}
                       backgroundMode={false}
                       sizePreset={2}
                       broadcasting={this.state.broadcasting}
                       muted={this.state.muted}
                       flashOn={this.state.flashEnabled}
                       frontCamera={this.state.frontCamera}
                       onBroadcastStart={this._didStartBroadcast}
                       onBroadcastFail={this._broadcastDidFailToStart}
                       onBroadcastStatusChange={this._broadcastStatusDidChange}
                       onBroadcastEventReceive={this._broadcastDidReceiveEvent}
                       onBroadcastErrorReceive={this._broadcastDidReceiveError}
                       onBroadcastVideoEncoded={this._broadcastVideoFrameEncoded}
                       onBroadcastStop={this._didStopBroadcast}
        >
        </BroadcastView>
        <Text style={styles.recordingTimerLabel}>
          {this.state.recordingTime}
        </Text>
        <View style={styles.cameraControls}>
          <TouchableOpacity onPress={() => {this.setState({frontCamera: !this.state.frontCamera})}}>
            <Image source={require('./assets/Flip.png')}></Image>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => {this.setState({broadcasting: !this.state.broadcasting})}}>
            <Image source={this.state.recordButtonImage} style={styles.cameraControlsButton}></Image>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => {this.setState({flashEnabled: !this.state.flashEnabled})}}>
            <Image source={require('./assets/Torch.png')} style={styles.cameraControlsButton}></Image>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  _didStartBroadcast = () =>{
    this.setState({
      recordButtonImage: require('./assets/Stop.png')
    });
  }

  _broadcastDidFailToStart = (error) =>{
    console.log('Failed to broadcast: ', error);
  }

  _broadcastStatusDidChange = (status) => {

  }

  _broadcastDidReceiveEvent = (event) =>{

  }

  _broadcastDidReceiveError = (error) =>{

  }

  _broadcastVideoFrameEncoded = (time) => {
    this.setState({recordingTime: this._formatCurrentTime(time.encoded)}, () => {
      console.log(this.state.recordingTime);
    });
  }

  _didStopBroadcast = () => {
    this.setState({
      recordButtonImage: require('./assets/Rec.png')
    });
  }

  _formatCurrentTime(currentTime) {
    let time = Number(currentTime);
    var h = Math.floor(time / 3600);
    var m = Math.floor(time % 3600 / 60);
    var s = Math.floor(time % 3600 % 60);
    return ((h > 0 ? h + ":" + (m < 10 ? "0" : "") : "00:") + (m > 0?m:"00") + ":" + (s < 10 ? "0" : "") + s);
  }
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
    justifyContent: 'center',
    flexDirection: 'row',
    alignItems: 'flex-end'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  contentArea: {
    position: 'absolute',
    top:0,
    left:0,
    right:0,
    bottom:0,
    backgroundColor: 'rgba(0,0,0,0.75)'
  },
  recordingTimerLabel: {
    position: 'absolute',
    top: 36
  },
  cameraControls: {
    marginBottom: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: width - 32
  },
  cameraControlsButton: {
    width: 60,
    height: 60
  }
});