//
//  CustomDatePicker.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 23/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

enum DatePickerType {
    case dob
    case dod
}

class CustomDatePicker: UIDatePicker {

    var type: DatePickerType = .dob

}
