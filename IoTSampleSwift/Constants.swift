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

import Foundation
import AWSCore

//WARNING: To run this sample correctly, you must set the following constants.

let CertificateSigningRequestCommonName = "IoTDemo"
let CertificateSigningRequestCountryName = "Turkey"
let CertificateSigningRequestOrganizationName = "Deloitte"
let CertificateSigningRequestOrganizationalUnitName = "Berk"
let PolicyName = "IoTDemoPolicy"

// This is the endpoint in your AWS IoT console. eg: https://xxxxxxxxxx.iot.<region>.amazonaws.com
let AWSRegion = AWSRegionType.USEast1 // e.g. AWSRegionType.USEast1
let IOT_ENDPOINT = "https://a3g5gcx3s4m2ka-ats.iot.us-east-1.amazonaws.com"
let ASWIoTDataManager = "MyIotDataManager"
