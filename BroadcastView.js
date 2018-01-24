import React, {Component} from 'react';
import { PropTypes } from "prop-types";
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
  hostAddress: PropTypes.string.isRequired,
  applicationName: PropTypes.string.isRequired,
  sdkLicenseKey: PropTypes.string.isRequired,
  broadcastName: PropTypes.string.isRequired,
  backgroundMode: PropTypes.bool,
  sizePreset: PropTypes.number,
  videoOrientation: PropTypes.oneOf(['landscape', 'portrait']),
  port: PropTypes.number,
  username: PropTypes.string.isRequired,
  password: PropTypes.string.isRequired,
  broadcasting: PropTypes.bool.isRequired,
  muted: PropTypes.bool,
  flashOn: PropTypes.bool,
  frontCamera: PropTypes.bool,
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
