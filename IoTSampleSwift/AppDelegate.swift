/*
* Copyright 2010-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import UIKit
import AWSCore
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // gyroscope monitoring
        

        // Setting up logging to xcode console.
        AWSDDLog.sharedInstance.logLevel = .debug
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        
        // Hockey App Settings
        MSAppCenter.start("f2a21df9-90fe-4ec0-8892-9499bb8d16e0", withServices:[ MSAnalytics.self, MSCrashes.self ])

        return true
    }
}

