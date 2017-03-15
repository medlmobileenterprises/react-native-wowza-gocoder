import React, {Component, PropTypes} from 'react';
import {StyleSheet, requireNativeComponent, NativeModules, View, DeviceEventEmitter, Platform} from 'react-native';
const BroadcastManager = NativeModules.BroadcastModule;

const styles = StyleSheet.create({
  base: {
    overflow: 'hidden',
  },
});

export default class BroadcastView extends Component {

  setNativeProps(nativeProps) {
    this._root.setNativeProps(nativeProps);
  }
  componentWillMount(){
    if(Platform.OS == 'android'){
      DeviceEventEmitter.addListener('broadcastTimer', (seconds) => {
        this.props.onBroadcastVideoEncoded({seconds:seconds})
      });
    }
  }
  _assignRoot = (component) => {
    this._root = component;
  };

  _onBroadcastStart = (event) => {
    if(Platform.OS == 'android'){
      BroadcastManager.startTimer(1.1, 3600);
    }
    if (this.props.onBroadcastStart) {
      this.props.onBroadcastStart(event.nativeEvent);
    }
  };

  _onBroadcastFail = (event) => {
    if (this.props.onBroadcastFail) {
      this.props.onBroadcastFail(event.nativeEvent);
    }
  };

  _onBroadcastStatusChange = (event) => {
    if (this.props.onBroadcastStatusChange) {
      this.props.onBroadcastStatusChange(event.nativeEvent);
    }
  };

  _onBroadcastEventReceive = (event) => {
    if (this.props.onBroadcastEventReceive) {
      this.props.onBroadcastEventReceive(event.nativeEvent);
    }
  };

  _onBroadcastErrorReceive = (event) => {
    if (this.props.onBroadcastErrorReceive) {
      this.props.onBroadcastErrorReceive(event.nativeEvent);
    }
  };

  _onBroadcastVideoEncoded = (event) => {
    if (this.props.onBroadcastVideoEncoded) {
      this.props.onBroadcastVideoEncoded(event.nativeEvent);
    }
  };

  _onBroadcastStop = (event) => {
    if (this.props.onBroadcastStop) {
      this.props.onBroadcastStop(event.nativeEvent);
    }
  };

  render() {
    const nativeProps = Object.assign({}, this.props);
    Object.assign(nativeProps, {
      style: [styles.base, nativeProps.style],
      onBroadcastStart: this._onBroadcastStart,
      onBroadcastFail: this._onBroadcastFail,
      onBroadcastStatusChange: this._onBroadcastStatusChange,
      onBroadcastEventReceive: this._onBroadcastEventReceive,
      onBroadcastErrorReceive: this._onBroadcastErrorReceive,
      onBroadcastVideoEncoded: this._onBroadcastVideoEncoded,
      onBroadcastStop: this._onBroadcastStop,

    });

    return (
        <RNBroadcastView
            ref={this._assignRoot}
            {...nativeProps}
        />
    );
  }
}

BroadcastView.propTypes = {
  hostAddress: React.PropTypes.string.isRequired,
  applicationName: React.PropTypes.string.isRequired,
  sdkLicenseKey: React.PropTypes.string.isRequired,
  broadcastName: React.PropTypes.string.isRequired,
  backgroundMode: React.PropTypes.bool,
  sizePreset :React.PropTypes.number,
  port: React.PropTypes.number,
  username: React.PropTypes.string.isRequired,
  password: React.PropTypes.string.isRequired,
  broadcasting: React.PropTypes.bool.isRequired,
  muted: React.PropTypes.bool,
  flashOn: React.PropTypes.bool,
  frontCamera: React.PropTypes.bool,
  onBroadcastStart: PropTypes.func,
  onBroadcastFail: PropTypes.func,
  onBroadcastStatusChange: PropTypes.func,
  onBroadcastEventReceive: PropTypes.func,
  onBroadcastErrorReceive: PropTypes.func,
  onBroadcastVideoEncoded: PropTypes.func,
  onBroadcastStop: PropTypes.func,
  ...View.propTypes,
};

const RNBroadcastView = requireNativeComponent('RNBroadcastView', BroadcastView);
