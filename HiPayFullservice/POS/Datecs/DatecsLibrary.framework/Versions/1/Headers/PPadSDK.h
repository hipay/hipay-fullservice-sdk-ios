//
//  PPad.h
//  DatecsLibraryTest
//
//  Created by Olaf van Zandwijk on 24-06-13.
//  Copyright (c) 2014 SepaSoft Development. All rights reserved.
//

//- getBatteryCapacity
//- playSound
//- deviceButtonPressed
//- connectionState (event)
//- barcodeData (event)

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

#define SOCKET_ALREADY_CONNECTED 2

#ifndef BARCODES_DEFINED
#define BARCODES_DEFINED
typedef enum {
	BAR_EX_ALL=0,
	BAR_EX_UPCA,
	BAR_EX_CODABAR,
	BAR_EX_CODE25_NI2OF5,
	BAR_EX_CODE25_I2OF5,
	BAR_EX_CODE39,
	BAR_EX_CODE93,
	BAR_EX_CODE128,
	BAR_EX_CODE11,
	BAR_EX_CPCBINARY,
	BAR_EX_DUN14,
	BAR_EX_EAN2,
	BAR_EX_EAN5,
	BAR_EX_EAN8,
	BAR_EX_EAN13,
	BAR_EX_EAN128,
	BAR_EX_GS1DATABAR,
	BAR_EX_ITF14,
	BAR_EX_LATENT_IMAGE,
	BAR_EX_PHARMACODE,
	BAR_EX_PLANET,
	BAR_EX_POSTNET,
	BAR_EX_INTELLIGENT_MAIL,
	BAR_EX_MSI_PLESSEY,
	BAR_EX_POSTBAR,
	BAR_EX_RM4SCC,
	BAR_EX_TELEPEN,
	BAR_EX_UK_PLESSEY,
	BAR_EX_PDF417,
	BAR_EX_MICROPDF417,
	BAR_EX_DATAMATRIX,
	BAR_EX_AZTEK,
	BAR_EX_QRCODE,
	BAR_EX_MAXICODE,
	BAR_EX_RESERVED1,
	BAR_EX_RESERVED2,
	BAR_EX_RESERVED3,
	BAR_EX_RESERVED4,
	BAR_EX_RESERVED5,
	BAR_EX_UPCA_2,
	BAR_EX_UPCA_5,
	BAR_EX_UPCE,
	BAR_EX_UPCE_2,
	BAR_EX_UPCE_5,
	BAR_EX_EAN13_2,
	BAR_EX_EAN13_5,
	BAR_EX_EAN8_2,
	BAR_EX_EAN8_5,
	BAR_EX_CODE39_FULL,
	BAR_EX_ITA_PHARMA,
	BAR_EX_CODABAR_ABC,
	BAR_EX_CODABAR_CX,
	BAR_EX_SCODE,
	BAR_EX_MATRIX_2OF5,
	BAR_EX_IATA,
	BAR_EX_KOREAN_POSTAL,
	BAR_EX_CCA,
	BAR_EX_CCB,
	BAR_EX_CCC,
	BAR_EX_LAST
}BARCODES_EX;
#endif

/** @defgroup G_PPERROR_CODES PinPad Error Codes
 @ingroup G_PINPAD
 Result codes from all PinPad functions
 @{
 */
/**
 No error
 */
#define ppErrNo					0
/**
 Generic error
 */
#define ppErrGeneral			1
/**
 Invalid command or subcommand code
 */
#define ppErrInvalidCommand		2
/**
 Invalid paremeter
 */
#define ppErrInvalidParameter	3
/**
 Address is outside limits
 */
#define ppErrInvalidAddress		4
/**
 Value is outside limits
 */
#define ppErrInvalidValue		5
/**
 Length is outside limits
 */
#define ppErrInvalidLength		6
/**
 The action is not permitted in current state
 */
#define ppErrNoPermit			7
/**
 There is no data to be returned
 */
#define ppErrNoData				8
/**
 Timeout occured
 */
#define ppErrTimeOut			9
/**
 Invalid key number
 */
#define ppErrKeyNum				10
/**
 Invalid key attributes (usage)
 */
#define ppErrKeyAttr			11
/**
 Calling of non-existing device
 */
#define ppErrInvalidDevice		12
/**
 (not used in this FW version)
 */
#define ppErrNoSupport			13
/**
 Pin entering limit exceed
 */
#define ppErrPinLimit			14
/**
 Error in flash commands
 */
#define ppErrFlash				15
/**
 Hardware error
 */
#define ppErrHardware			16
/**
 (not used in this FW version)
 */
#define ppErrInvalidCRC			17
/**
 The button "CANCEL" is pressed
 */
#define ppErrCancel				18
/**
 Invalid signature
 */
#define ppErrInvalidSignature	19
/**
 Invalid data in header
 */
#define ppErrInvalidHeader		20
/**
 Incorrent password
 */
#define ppErrInvalidPassword	21
/**
 Invalid key format
 */
#define ppErrKeyFormat			22
/**
 Error in smart card reader
 */
#define ppErrSCR				23
/**
 Error code is returned from HAL functions
 */
#define ppErrHAL				24
/**
 Invalid key (or missing)
 */
#define ppErrInvalidKey			25
/**
 The PIN length is <4 or >12
 */
#define ppErrNoPinData			26
/**
 Issuer or ICC key invalid remainder length
 */
#define ppErrInvalidRemainder	27
/**
 (no used in this FW version)
 */
#define ppErrNoInit				28
/**
 (no used in this FW version)
 */
#define ppErrLimit				29
/**
 (no used in this FW version)
 */
#define ppErrInvalidSequence	30
/**
 The action is not permited
 */
#define ppErrNoPerm				31
/**
 TMK is not loaded. The action cannot be executed
 */
#define ppErrNoTMK				32
/**
 Wrong key format
 */
#define ppErrWrongKey			33
/**
 Duplicated key
 */
#define ppErrDuplicateKey		34

/**@}*/

#define EVENT_BUTTON1_PRESS 0x0002
#define EVENT_BUTTON1_RELEASE 0x0004
#define EVENT_BUTTON1 (EVENT_BUTTON1_PRESS+EVENT_BUTTON1_RELEASE)
#define EVENT_BUTTON2_PRESS 0x0008
#define EVENT_BUTTON2_RELEASE 0x0010
#define EVENT_BUTTON2 (EVENT_BUTTON2_PRESS+EVENT_BUTTON2_RELEASE)
#define EVENT_BARCODE 0x0020
#define EVENT_MAGNETIC_CARD 0x0040
#define EVENT_SMART_CARD_INSERT 0x0080
#define EVENT_SMART_CARD_REMOVE 0x0100
#define EVENT_SMART_CARD (EVENT_SMART_CARD_INSERT+EVENT_SMART_CARD_REMOVE)

#define EVENT_ALL -1

typedef struct hardwareInfo
{
	union
	{
		int charging:1;
		int lowBattery:1;
		int veryLowBattery:1;
		int externalPower:1;
	}flags;
	int batteryPercent;
	int batteryVoltage;
}hardwareInfo;

/**
 * Connection state
 */
#ifndef CONNSTATES_DEFINED
#define CONNSTATES_DEFINED
typedef enum {
	CONN_DISCONNECTED=0,
	CONN_CONNECTING,
	CONN_CONNECTED
}CONN_STATES;
#endif

@protocol PPadCustomDelegate
@optional
/** @defgroup G_PPDELEGATE Delegate Notifications
 @ingroup G_PINPAD
 Notifications sent by the sdk on various events - barcode scanned, magnetic card data, communication status, etc
 @{
 */

/**
 Notifies about the current connection state
 @param state - connection state, one of:
 <table>
 <tr><td>CONN_DISCONNECTED</td><td>there is no connection to PPad and the sdk will not try to make one</td></tr>
 <tr><td>CONN_CONNECTING</td><td>PPad is not currently connected, but the sdk is actively trying to</td></tr>
 <tr><td>CONN_CONNECTED</td><td>PPad is connected</td></tr>
 </table>
 **/
-(void)ppadConnectionState:(int)state;

/**
 Notification sent when some of the device's buttons is pressed
 @param which button identifier, one of:
 <table>
 <tr><td>0</td><td>right scan button</td></tr>
 </table>
 **/
-(void)deviceButtonPressed:(int)which;

/**
 Notification sent when some of the device's buttons is released
 @param which button identifier, one of:
 <table>
 <tr><td>0</td><td>right scan button</td></tr>
 </table>
 **/
-(void)deviceButtonReleased:(int)which;

/**
 Notification sent when barcode is successfuly read
 @param barcode - string containing barcode data
 @param type - barcode type, one of the BAR_* constants
 **/
-(void)barcodeData:(NSString *)barcode type:(int)type;

-(void)batteryCapacity:(int)capacity;

-(void)deviceUID:(NSString *)deviceUID;

-(void)currentSoftwareVersion:(NSString *)currentSoftwareVersion;

-(void)availableSoftwareVersion:(NSString *)availableSoftwareVersion;

/**@}*/

@end

/**
 Provides access to pinpad functions.
 */
@interface PPadCustom : NSObject<EAAccessoryDelegate,NSStreamDelegate>{
@private
@public
}

/** @defgroup G_PPGENERIC Generic Functions
 @ingroup G_PINPAD
 This section includes commands for setting delegate, connecting and disconnecting, utility functions
 @{
 */

/**
 Creates and initializes new PPad class instance or returns already initalized one. Use this function, if you want to access PPad from multiple classes.
 @return shared instance of PPad class
 **/
+(id)sharedDevice;

/**
 Allows unlimited delegates to be added to a single PPad instance. This is useful in the case of global PPad class and every view
 can use addDelegate when the view is shown and removeDelegate then no longer needs to monitor PPad events
 @param newDelegate - the delegate that will be notified of PPad events
 *****/
-(void)addDelegate:(id)newDelegate;

/**
 Removes delegate, previously added with addDelegate
 @param delegateToBeRemoved - the delegate to be removed
 **/
-(void)removeDelegate:(id)delegateToBeRemoved;

/**
 Re-fires the ppadConnectionState event
 **/
-(void)requestConnectionState;

/**
 Tries to connect to PPad in the background, connection status notifications will be passed through the delegate.
 Once connect is called, it will automatically try to reconnect until disconnect is called.
 Note that "connect" call works in background and will notify the caller of connection success via connectionState delegate.
 Do not assume the library has fully connected to the device after this call, but wait for the notification.
 **/
-(void)connect;

/**
 Stops the sdk from trying to connect to PPad and breaks existing connection.
 **/
-(void)disconnect;

/**
 Helper function to get the name of specific barcode type.
 @param barcodeType - barcode type, one of the BAR_* constants
 @return barcode type as string
 **/
-(NSString *)barcodeType2Text:(int)barcodeType;

-(int)getBatteryCapacity;

/**
 Returns active device's battery capacity
 @note Reading battery voltages during charging is unreliable!
 @param capacity returns battery capacity in percents, ranging from 0 when battery is dead to 100 when fully charged. Pass nil if you don't want that information
 @param voltage returns battery voltage in Volts, pass nil if you don't want that information
 @param error pointer to NSError object, where error information is stored in case function fails. You can pass nil if you don't want that information
 @return TRUE if function succeeded, FALSE otherwise
 */
-(BOOL)getBatteryCapacity:(int *)capacity voltage:(float *)voltage error:(NSError **)error;

-(NSString *)getDeviceUID;
-(NSString *)requestCurrentSoftwareVersion;
-(NSString *)requestAvailableSoftwareVersion;
-(void)kick;

-(BOOL)startSoftwareUpdate;

-(void)connectTest;

/**
 Plays a sound using the built-in speaker on the active device
 @note A sample beep containing of 2 tones, each with 400ms duration, first one 2000Hz and second - 5000Hz will look int beepData[]={2000,400,5000,400}
 @param volume controls the volume (0-100). Currently have no effect
 @param data an array of integer values specifying pairs of tone(Hz) and duration(ms).
 @param length length in bytes of beepData array
 @param error pointer to NSError object, where error information is stored in case function fails. You can pass nil if you don't want that information
 @return TRUE if function succeeded, FALSE otherwise
 */
-(BOOL)playSound:(int)volume beepData:(int *)data length:(int)length error:(NSError **)error;

/**
 Restarts the pinpad.
 **/
-(void)sysRestart;

-(void)allowConnectMessage;

-(NSString *)getVersion;

/**
 Adds delegate to the class
 **/
@property(assign) id delegate;
/**
 Returns current connection state
 **/
@property(readonly) CONN_STATES connstate;


/**@}*/

@end

