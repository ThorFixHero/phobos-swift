//
//
//  CLLocationManager+Ex.swift
//  PhobosSwiftLocation
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import CoreLocation
import Foundation
import MapKit

extension CLLocationManager {
  enum AssociatedKeys {
    static var shouldDisplayHeadingCalibration: UInt8 = 0
    static var authorizationStatus: UInt8 = 1
  }
}

extension CLLocationManager {
  /// default LLocationManager
  public static var `default` = pbs_makeLocationManager(desiredAccuracy: kCLLocationAccuracyBestForNavigation)

  static func pbs_makeLocationManager(desiredAccuracy: CLLocationAccuracy) -> CLLocationManager {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    manager.pbs_shouldDisplayHeadingCalibration = true
    return manager
  }

  /// Escalate the authorization is set to when-in-use
  public func pbs_escalateLocationServiceAuthorization() {
    // Escalate only when the authorization is set to when-in-use
    if #available(iOS 14.0, *) {
      if self.authorizationStatus == .authorizedWhenInUse {
        self.requestAlwaysAuthorization()
      }
    } else {
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
        requestAlwaysAuthorization()
      }
    }
  }

  /// Returns a Boolean value indicating whether location services are enabled on the device.
  ///
  public var pbs_isLocationServicesEnabled: Bool {
    CLLocationManager.locationServicesEnabled()
  }

  public var pbs_shouldDisplayHeadingCalibration: Bool {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.shouldDisplayHeadingCalibration) as? Bool else {
        return true
      }
      return value
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociatedKeys.shouldDisplayHeadingCalibration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }
  }

  /// 获取最后一次的定位权限状态
  var _pbs_authorizationStatus: CLAuthorizationStatus? {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.authorizationStatus) as? CLAuthorizationStatus else {
        return nil
      }
      return value
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociatedKeys.authorizationStatus, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
  }

  /// The current authorization status for the app.
  public var pbs_authorizationStatus: CLAuthorizationStatus? {
    if #available(iOS 14.0, *) {
      return self.authorizationStatus
    } else {
      return _pbs_authorizationStatus
    }
  }

  /// starting / stop updating location
  func pbs_updatingLocation(updating: Bool) {
    if updating {
      if pbs_isLocationServicesEnabled {
        startUpdatingLocation()
      } else {}
    } else {
      stopUpdatingLocation()
    }
  }

  /// 在默认的地图中打开导航
  public static func showRouteInBuitinMap(sourceLocation: MKMapItem,
                                          destLocation: MKMapItem,
                                          directionsMode: DirectionsMode = .walk) {
    MKMapItem.openMaps(with: [sourceLocation, destLocation],
                       launchOptions: directionsMode.launchOptions)
  }

  /// 在默认的地图中打开导航
  public static func showRouteInBuitinMap(destLocation: MKMapItem,
                                          directionsMode: DirectionsMode = .walk) {
    let sourceLocation = MKMapItem.forCurrentLocation()
    Self.showRouteInBuitinMap(sourceLocation: sourceLocation,
                              destLocation: destLocation,
                              directionsMode: directionsMode)
  }
}
