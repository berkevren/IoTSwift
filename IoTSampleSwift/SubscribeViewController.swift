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
import AVFoundation

class SubscribeViewController: UIViewController {

    @IBOutlet weak var subscribeSlider: UISlider!
    let awsShadowGetTopic = "$aws/things/berksiphone/shadow/get"
    let awsShadowGetAcceptedTopic = "$aws/things/berksiphone/shadow/get/accepted"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        subscribeSlider.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManager)
        let connectionViewController = ConnectionViewController()
        
        iotDataManager.subscribe(toTopic: awsShadowGetAcceptedTopic, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
            self.actTorchDesiredState(payload: payload)
            self.actCameraDesiredState(payload: payload)
            self.actAlertMessageDesiredState(payload: payload)
            })
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(getShadowState), userInfo: nil, repeats: true)
        } else {
            connectionViewController.alertIncompatibleVersion()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManager)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        iotDataManager.unsubscribeTopic(tabBarViewController.topic)
    }
    
    func actTorchToggle(payload: Data) {
        let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
        
        if(stringValue.floatValue == 0) {
            self.toggleTorch(on: true)
        } else {
            self.toggleTorch(on: false)
        }
    }
    
    func actTorchDesiredState(payload: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any]
            let jsonState = json?["state"] as? NSDictionary
            let jsonStateDesired = jsonState?["desired"] as? NSDictionary
            let jsonStateDesiredFlashlightStatus = jsonStateDesired?["flashlight"] as! String
            
            if(jsonStateDesiredFlashlightStatus == "on") {
                self.toggleTorch(on: true)
            } else {
                self.toggleTorch(on: false)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                alertMessage(message: "Flashlight could not be used")
            }
        } else {
            alertMessage(message: "Flashlight is not available")
        }
    }
    
    func actCameraDesiredState(payload: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any]
            let jsonState = json?["state"] as? NSDictionary
            let jsonStateDesired = jsonState?["desired"] as? NSDictionary
            let jsonStateDesiredFlashlightStatus = jsonStateDesired?["camera"] as! String
            print(jsonStateDesiredFlashlightStatus)
            
            if(jsonStateDesiredFlashlightStatus == "on") {
                self.openCamera()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentCamera()
        } else {
            alertMessage(message: "Camera not available")
        }
    }
    
    func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func actAlertMessageDesiredState(payload: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: payload, options: []) as? [String: Any]
            let jsonState = json?["state"] as? NSDictionary
            let jsonStateDesired = jsonState?["desired"] as? NSDictionary
            let jsonStateDesiredAlertStatus = jsonStateDesired?["alertmessage"] as! String
            let jsonStateDesiredAlertMessage = jsonStateDesired?["message"] as! String
            
            if(jsonStateDesiredAlertStatus == "on") {
                alertMessage(message: jsonStateDesiredAlertMessage)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func getShadowState() {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManager)
        let emptyJSON: Data? = "{}".data(using: .utf8)
        iotDataManager.publishData(emptyJSON!, onTopic: awsShadowGetTopic, qoS: .messageDeliveryAttemptedAtMostOnce)
    }
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

