# FreeAPS X

FreeAPS X - an artificial pancreas system for iOS based on [OpenAPS Reference](https://github.com/openaps/oref0) algorithms

FreeAPS X uses original JavaScript files of oref0 and provides a user interface (UI) to control and set up the system

## Documentation

[Overview on Loop&Learn](https://www.loopandlearn.org/freeaps-x/)

[OpenAPS documentation](https://openaps.readthedocs.io/en/latest/)

## Smartphone requirements

- All iPhones which support iOS 14 and up.

## Supported pumps

To control an insulin pump FreeAPS X uses modified [rileylink_ios](https://github.com/ps2/rileylink_ios) library, thus supporting the same pump list:

- Medtronic 515 or 715 (any firmware)
- Medtronic 522 or 722 (any firmware)
- Medtronic 523 or 723 (firmware 2.4 or lower)
- Medtronic Worldwide Veo 554 or 754 (firmware 2.6A or lower)
- Medtronic Canadian/Australian Veo 554 or 754 (firmware 2.7A or lower)
- Omnipod "Eros" pods

To control an insulin you need to have a [RileyLink](https://getrileylink.org), OrangeLink, Pickle, GNARL, Emalink or similar device

## Current state of FreeAPS X

FreeAPS X is in an active development state and changes frequently.

You can find a description of versions on the [releases page](https://github.com/ivalkou/freeaps/releases).

### Stable versions

A stable version means that it has been tested for a long time and does not contain critical bugs. We consider it ready for everyday use.

Stable version numbers end in .0 and the code can be found in the [master branch](https://github.com/ivalkou/freeaps/tree/master).

The current stable version is 0.2.0.

### Beta versions

Beta versions are the first to introduce new functionality. They are designed to test and identify issues and bugs.

**Beta versions are not recommended for daily use for blood glucose control!**

Beta numbers end with a number greater than 0, and the code can be found in the [dev brunch](https://github.com/ivalkou/freeaps/tree/dev).

Pull requests are accepted on the dev branch.

Bug reports and feature requests are accepted on the [Issues page](https://github.com/ivalkou/freeaps/issues).

## Implemented

- All base functions of oref0
- All base functions of oref1 (SMB, UAM and others)
- Autotune
- Autosens
- Nightscout BG data source as a CGM (Online)
- Applications that mimic Nightscout as a CGM (apps like Spike and Diabox) (Offline)
- xDrip4iOS data source as a CGM via shared app gpoup (Offline)
- System state upload to Nightscout
- Remote carbs enter and temporary targets through Nightscout
- Remote bolusing and insulin pump control

## Not implemented (plans for future)

- Open loop mode
- Phone notifications of the system and connected devices state
- Profile upload to Nightscout
- Desktop widget
- Apple Watch app
- Plugins
- Dexcom support
- Enlite support
- Apple Health support
- Detailed functions description inside the app

## Community

- [English Telegram group](https://t.me/freeapsx_eng)
- [Russian Telegram group](https://t.me/freeapsx)

