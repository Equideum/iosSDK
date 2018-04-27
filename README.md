## FhirBlocks SDK
FhirBlocks is a sovereign trust framework for healthcare applications. FhirBlocks enables qualified parties to establish trust across different actors, apps, and devices so that they may access broadly distributed "pools" of healthcare data, all while preserving data access permissions and chain of custody audit mechanisms. FhirBlocks is sovereign in the sense that no single commercial party controls the framework. Sovereignty is achieved with the FhirBlocks protocol design itself, the open-source approach to managing the technical development project, and the governance structure of the FhirBlocks Foundation.

#### FBlocksCSA App  
To interact with this ecosystem system a user is required to register the respective device with the ecosystem using FBlocksCSA App. Once registered using the HealthWallet App, the user will be given a csiGuid(36 character string that uniquely identify the <app,device> pair. Sample key 7c5b8363-504b-4f83-9d01-caa4e28a156e) which is used to identity in the further process. Wallet app acts as authorizing and monitoring authority for shared access of users health data. Its a single point repository that shows all data sharing done by the user to various health care applications (registered with FhirBlocks ) referred to as mHeath Apps and these are developed using the FHIRBlocks SDK or FHIRBlocks enabled using the SDK.

#### mHealth App  
mHealth apps are mobile applications that are developed using FhirBlocks sdk. This document will help you understand how to interact with FhirBlocks using SMOAC API and wallet app. A sample mHealth app (namely mHealthDApp ) implementation can be downloaded from here.

mHealthDApp is a mock-up of an mHealth App featuring the protocols SMOAC, OAUTH2, and the FHIR Server inter-working. It is an iOS app that demonstrates the overall flow of registering an mHealth app with FhirBlocks (FhirBlocks), authenticating with the FhirBlocks "VACA" function, and then making a request for patient information against a FhirBlocks protected FHIR resource server.


## App Configuration      

#### 1. Download FhirBlocks HealthWallet (FBlocksCSA)  
All mHealth apps work in conjunction with FBlocksCSA app (Fblocks Client System App). FBlocksCSA with its multifaceted trust model let’s you maintain all your permissioned mHealth apps and their corresponding required resources in one place securely and access them with ease for your review. It lets you check various mHealth apps permissioned by you, it stores the user identity upon registration at server end, the mHealth apps can access various resources shared by the FBlocksCSA for the duration specified by the user. Therefore the mHealth apps can only work in conjunction with the FBlocksCSA as it grants the permission to mHealth apps to be FHIRBlocks enabled. You can download the FblocksCSA app for free from the Apple AppStore.

#### 2. Encryption  
The FHIRBlocks SDK implements secure communication system with the help of private & public key encryption(Asymmetric Encryption).You should be aware of the iOS API’s for implementing the same.
You can generate private & public key (key pair) via the following code

```obj-c  
// Private Key Attributes Dictionary 
NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];

// Public Key Attributes Dictionary
NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];

// Key Pair Attributes Dictionary
NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
    
// Application Tags for Public & private
NSData *publicTag = [@"EC" dataUsingEncoding:NSUTF8StringEncoding];
NSData *privateTag = [@"EC" dataUsingEncoding:NSUTF8StringEncoding];
    
SecKeyRef publicKey = NULL;
privateKey = NULL;

// Type of Algorithm for key generation
[keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeEC
                forKey:(__bridge id)kSecAttrKeyType];
[keyPairAttr setObject:[NSNumber numberWithInt:256]
                forKey:(__bridge id)kSecAttrKeySizeInBits];
    
[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
[privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    
[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
[publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    
[keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
[keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
// Keys Generation
OSStatus err = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
```

For the signature generation the algorithm used is as following

```obj-c
algorithm = kSecKeyAlgorithmECDSASignatureMessageX962SHA256;
```

Use the following code for creating signature
```obj-c
-(NSData*)createSignature:(NSData*)data2sign withKey:(SecKeyRef)privateKey
{
    BOOL canSign = SecKeyIsAlgorithmSupported(privateKey, kSecKeyOperationTypeSign, algorithm);    
    
    NSLog(@"Can You sign: %@",canSign ? @"YES" : @"NO");
    
    NSData* signature = nil;
    if (canSign) {
        CFErrorRef error = NULL;
        signature = (NSData*)CFBridgingRelease(       
          // ARC takes ownership
          SecKeyCreateSignature(privateKey, algorithm, (__bridge CFDataRef)data2sign, &error));
        if (!signature) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            NSLog(@"%@", err);
            // Handle the error. . .
        }
    } 
    return signature;
}
```

#### 3. URL Schemes  
A complete understanding of the implementation of inter app communication using the URL Scheme is a prerequisite to for the successful development of a FhirBlocks enabled mHealth App. URL scheme is utilized to pass data between the mHealth App and the FBlocksCSA app.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
  <dict>
    <key>CFBundleURLName</key>
      <string>com.example.com</string>
    <key>CFBundleURLSchemes</key>
      <array>
	<string>mHealthDApp</string>
      </array>
   </dict>
</array>
</plist>
```

You to need save the scheme of your app in info.plist in URL types attribute in the info.plist & add both your & CSA app’s schemes in LSApplicationQueriesSchemes as follows

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <array>
    <string>mHealthDApp</string>
    <string>FBlocksCSA</string>
  </array>
</plist>
```

Check out the <link> of example DApp with systematic steps for setup as follows.


#### 4.  Initial Configuration  
DApp,first of all will check whether CSA(wallet) is installed on the device for checking the same for your app, you need to use following code

```obj-c  
NSString *fBlocksCSA=@"FBlocksCSA://?scheme=mHealthDApp";
BOOL canOpenURL=[[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:fBlocksCSA]];
```

The CSA app will have the above mentioned URL scheme i.e FBlocksCSA the scheme of your app will be shared by you to CSA

If CSA is installed your app will check whether the UniqueIdentifier & csi of (got after registration with wallet) is shared with your app or not, you can store them both in user defaults & check as follows, if there are available proceed with the server calls for DApp

```obj-c
if([[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"] == nil 
	|| [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"] == nil)
{
  // prompt for registration for CSA
}
else
{
  // start the respective calls for DApp
}
```

##  Authentication Workflow  

> Note: You can access the FHIRBlocks API Swagger definitions at the following site.  
> `GET http://smoac.fhirblocks.io/`  



#### Step 1. Ping The Server  
```sh
GET http://smoac.fhirblocks.io:8080/util/ping
```  
The following will provide the version of FhirBlocks server.  
 
#### Step 2. Check the System Time  
```
GET http://smoac.fhirblocks.io:8080/util/getTime
```  
If the system is off by more than 5 minutes, consider error workflow.  

#### Step 3. Obtain A Globally Unique Identifier (GUID)  
```
GET http://smoac.fhirblocks.io:8080/util/getGloballyUniqueIdentifier
```
The GUID will be needed for identifying the app instance later in the workflow.


#### Step 4.  Register the csiGuid for the Distributed App (DApp)  

```
GET http://smoac.fhirblocks.io:8080/csi/requestCsiRegistration
```

Check swagger implementation for the request parameters.  Make the payload as follows

```obj-c
payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"|",@"ecdsa",@"|",derKeyString,@"|",deviceId,@"|",currentDate,@"|",nonce,@"|",@"[{",@"\"key\": \"DateofBirth\", \"value\": \"",@"",@"\"},",@"{\"key\": \"FirstName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"MiddleName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"LastName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"Gender\", \"value\": \"",@"",@"\"}",@"]",@"|"];
```

> _derKeyString_ 	- Public Key    
> _device ID_    	- Unique Identifier of device received from FBlocksCSA  
> _current date_ 	- Current server time  
> _nonce_        	- Random 32 digit string  


#### Step 5. Proceed with fetchPublicClaims of corresponding FBlocksCSA instance   

```
GET http://smoac.fhirblocks.io:8080/csi/fetchPublicClaims
```
Check swagger implementation for the request parameters.  Construct the the payload as follows:  

```obj-c  
payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"|",desiredGuid,@"|",currentDate,@"|",nonce,@"|"];
```

> _desiredGuid_  - csiguid of corresponding CSA instance  
> _current date_ - Current server time  
> _nonce_        - Random 32 digit string  


#### Step 6. Authorisation/Permission by corresponding FBlocksCSA instance  

Share the csiguid of DApp to the corresponding FBlocksCSA(Wallet) instance via URL scheme`

```obj-c
NSString *fBlocksCSA=[NSString stringWithFormat:@"FBlocksCSA://?dcsi=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]];
[[UIApplication sharedApplication]openURL:[NSURL URLWithString:fBlocksCSA] options:@{} completionHandler:nil];
```

Wallet then grants the permission to the DApp instance 

#### Step 7. mHealthDApp grants the permission to providers & caregivers

```
GET http://smoac.fhirblocks.io:8080/permission/writePermission
```

mHealthDApp is only allowed to grant permissions to providers & caregivers only when it is authorised or has received permissions from the corresponding DApp

Check swagger implementation for the request parameters.  Construct the payload as follows

```obj-c
NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@"
  ,@"|",endDateInRequiredFormat,@"|",startDateInRequiredFormat,@"|"];
    NSMutableString * payloadMutableString = [NSMutableString stringWithFormat:@"%@", payload];
    for (NSString * string in permissionCsiGuids) {
        [payloadMutableString appendString:[NSString stringWithFormat:@"%@|",string]];
    }
    [payloadMutableString appendString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"Patient",@"|",guid,@"|",currentDate,@"|",nonce,@"|"]];
```
> _endDateInRequiredFormat_  	- endTime for permission duration   
> _startDateInRequiredFormat_ 	- startTime for permission duration   
> _permissionCsiGuids_        	- guid to be given the permission   
> _patient_                   	- Permission Type   
> _V_				- Confidentiality Scope  
> _ETH(array[0])_		- Sensitivity Scope  
> _ETH(array[1])_		- Sensitivity Scope   
> _Patient_			- Resource Scope  
> _guid_			- csiguid of mHealth instance  
> _currentDate_			- Current server time  
> _nonce_			- Random 32 digit string  

#### Step 8. Auth Call Implementation  

```sh
# Auth_Base_URL
http://smoac.fhirblocks.io:8080/vaca/auth
```

Creation of JWT:

```obj-c
// Header String
[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"alg\"",@":\"",@"ES256",@"\",",@"\"typ\"",@":\"",@"jwt",@"\"}"];

// Body String(Payload)
double epochSeconds = [[NSDate date] timeIntervalSince1970];
double expireTimeInSecondsSinceEpoch = epochSeconds + AUTHORIZATION_TOKEN_LIFESPAN_IN_SECONDS; 

// AUTHORIZATION_TOKEN_LIFESPAN_IN_SECONDS = 300
NSString * bodyString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%d%@%@%@%d%@%@%@%@%@%@%@%@%@%@%@%@%@",@"{\"iss\"",@":\"", [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\",",@"\"sub\"",@":\"", [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\",",@"\"aud\"",@":\"",Auth_Base_URL,@"\",",@"\"iat\"",@":\"",(int)epochSeconds,@"\",",@"\"exp\"",@":\"",(int)expireTimeInSecondsSinceEpoch,@"\",",@"\"jti\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"\",",@"\"scope\"",@":\"",@"patient/Patient.read sens/ETH sens/SOC conf/V",@"\",",@"\"sta\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"\"}"];


[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"]    // Unique Identifier of device received from CSA
[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"] 		  // csiguid of mHealth instance
```

Signature
> _bodyString_  - Payload for the signature   
> Body Encoded String
> Base 64 Encoded string for Body String


JWT

```obj-c  
NSString * finalAssembly = [NSString stringWithFormat:@"%@.%@.%@",headerEncodedString,bodyEncodedString,signatureString];
```
JWT is formed by appending Header Encoded String,Body Encoded String & Signature String with ”.” between them

URL Encoded String

```obj-c
urlEncodedString = [NSString stringWithFormat:@"%@%@",@"grant_type=authorization_code&assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&assertion=",finalAssembly];
```

URL Encoded String is posted to the server with @"application/x-www-form-urlencoded" for @"Content-Type" header field in the POST request

#### Step 9. Access Call Implementation  
```sh
// Access_Base_URL
GET http://smoac.fhirblocks.io:8080/vaca/access
```
Create the JSON Web Token (JWT) as follows:

```obj-c  
// Header String  
NSString * headerString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"kid\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\",",@"\"alg\"",@":\"",@"ES256",@"\"}"];

[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"] - csiguid of mHealth instance

// Body String(Payload)
NSString * bodyString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"code\"",@":\"",[authCodeDictionary objectForKey:@"code"],@"\",",@"\"iss\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\"}"];

[authCodeDictionary objectForKey:@"code"]   			// Received in auth call response
[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"] 	// csiguid of mHealth instance

// JWT
NSString * finalAssembly = [NSString stringWithFormat:@"%@.%@ %@“, headerEncodedString, bodyEncodedString,signatureString];
```

> bodyString - Payload for the signature 


JWT is formed by appending Header Encoded String,Body Encoded String & Signature String with ”.” between them


```obj-c
// URL Encoded String
urlEncodedString = [NSString stringWithFormat:@"%@%@%@%@",@"grant_type=authorization_code&code=",[authCodeDictionary objectForKey:@"code"],@"&client_assertion_type=urn%3Aietf%3Aparams%3Aoauth%3Aclient-assertion-type%3Ajwt-bearer&client_assertion=",finalAssembly];
```

URL Encoded String is posted to the server with @"application/x-www-form-urlencoded" for @"Content-Type" header field in the POST request

#### Step 10.  fetchPermissionsGivenByMe Implementation  

```sh
GET http://smoac.fhirblocks.io:8080/permission/fetchPermissionsGivenByMe
```
Check swagger implementation for the request parameters.  Make the payload as follows

```obj-c
NSString *payload=[NSString stringWithFormat:@“%@%@%@%@%@%@%@",@"|",guid,@"|",currentDate,@"|",nonce,@"|"];
```

> _guid_  		- csiguid of mHealth instance  
> _current date_ 	- Current server time  
> _nonce_        	- Random 32 digit string  


#### Step 11. fetchPermissionsGivenToMe Implementation 

```sh
GET http://smoac.fhirblocks.io:8080/permission/fetchPermissionsGivenToMe
```

Check swagger implementation for the request parameters.  Make the payload as follows:

```obj-c
NSString *payload=[NSString stringWithFormat:@“%@%@%@%@%@" ,@"|",currentDate,@"|",nonce,@"|"];
```
> _current date_ 	- Current server time  
> _nonce_        	- Random 32 digit string  


## References & Links  
[https://fhirblocks.github.io/fhirblocks.org/](https://fhirblocks.github.io/fhirblocks.org/) - FHIRBlocks Homepage  
[https://github.com/fhirblocks](https://github.com/fhirblocks) - FHIRBlocks GitHub Account   
[http://smoac.fhirblocks.io/](http://smoac.fhirblocks.io/) - SMOAC Swagger API Reference  

## Copyright

Copyright 2018 The FHIRBlocks Project

Information contained herein is provided under the Apache 2.0 License

FHIR® is a trademark owned by Health Level Seven International and registered with the US Patent & Trademark Office;
and, “The FHIRBlocks Project” title is being used under HL7 Intl permission and, therefore, it is not to be extended
to other uses without HL7’s express written permission.

