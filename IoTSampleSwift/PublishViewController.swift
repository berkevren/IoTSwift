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
import AWSIoT

class PublishViewController: UIViewController {

    @IBOutlet weak var publishSlider: UISlider!

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManager)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        iotDataManager.publishData(createJSONTextFromSliderValue(sliderValue: sender.value), onTopic: tabBarViewController.topic, qoS: .messageDeliveryAttemptedAtMostOnce)
        
        if ( Double(sender.value) > 30.0) {
            alertWhenSliderGoesAbove30()
            self.publishSlider.value = 29
            iotDataManager.publishString("Slider Went Over 30.0. Override to 29.0.", onTopic:tabBarViewController.topic, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
    }
    
    func createJSONTextFromSliderValue(sliderValue: Float) -> Data {
        let publishJSONObject = populateJSONData(sliderValue: sliderValue)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: publishJSONObject, options: JSONSerialization.WritingOptions()) as NSData
            return jsonData as Data
            
        } catch _ {
            let emptyData = "error".data(using: .utf8)
            return emptyData!
        }
    }
    
    func populateJSONData(sliderValue: Float) -> NSMutableDictionary {
        let publishJSONObject: NSMutableDictionary = NSMutableDictionary()
        
        publishJSONObject.setValue(sliderValue, forKey: "payload")
        publishJSONObject.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "Device ID")
        publishJSONObject.setValue("Berk's iPhone", forKey: "Device")
        publishJSONObject.setValue("Berk", forKey: "Owner of Device")
        publishJSONObject.setValue("Erdem", forKey: "Coolest Person Around the Owner of Device")
        
        return publishJSONObject
    }
    
    func alertWhenSliderGoesAbove30() {
        let alert = UIAlertController(title: "Alert", message: "Slider has gone higher than 30. Please reduce.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
