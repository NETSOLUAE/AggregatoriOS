//
//  Constants.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Foundation

class Constants {
    let VEHICLE_USAGE = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/usageType";
    let VEHICLE_TYPE = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/getvehicleType/";
    let VEHICLE_MAKE = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/makes";
    let VEHICLE_MODEL = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/allmodels"
    let VEHICLE_VARIANT = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/variants/"
    let VEHICLE_RTO = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/master/rto"
    let BASE_URL = "http://netsolintl.net/aggrigator/aggregate.php?action_id="
    let COMPANY_DETAILS = "http://sample-env-3.xeixwpezdk.us-east-1.elasticbeanstalk.com/rest/quote/allquotes/Motor/PC"
    let errorMessage = "Oops! Our server is busy. Can you retry later.";
    let mobileNumberErrorMessage = "Please Enter your Phone Number";
    let nationalIdErrorMessage = "Please Enter your National ID";
}
