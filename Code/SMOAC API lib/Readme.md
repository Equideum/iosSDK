## Getting Started
These instructions will tell you how to copy mHealthDAppApiHandler into your peoject.

## Prequisites
You need downloaded library of mHealthDAppApiHandler. It will consist of folder which has name 'Include' and libmHealthApiHandler.a

## Installing

1.  Copy the downloaded folder 'Include' and  libmHealthApiHandler.a and paste it in the project where you have your .pbxproject file i.e root folder
2.  Now open xcode and click to add new 'Header Search Path' in the project.
3.  Double click on the Header Search Paths item, and a popover will appear. Click the + button, and enter the following:
$SOURCE_ROOT/include
4.  Now Select the Build Phases tab, and expand the Link Binary With Libraries section. Finally, click the + button in that section.
5.  In the window that appears, click on the Add Other… button and locate the libmHealthApiHandler.a library file in the lib subdirectory inside the project’s root folder,
6.  The final step is to add the -ObjC linker flag.Click on the Build Settings tab, and locate the Other linker Flags setting. In the popover, click on the + button and type -ObjC
7.  Finally, build and run your app

## Code

1. For Method Ping & Get Time & get Globally Unique Identifier:
It will send endpoint Ping and get time. This call has method type ‘GET’

#### Method:
```obj-c
-(void)createSessionWithEndPoint:(NSString*)endPoint;
```
#### How to Use:
```obj-c
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
apiHandler.delegate =  self;
```
1.For Ping
```obj-c
[apiHandler createSessionWithEndPoint:@”ping”];
```
2.For Get time
```obj-c
[apiHandler createSessionWithEndPoint:@”getTime”];
```
3.For Globally Unique Identifier
```obj-c
[apiHandler createSessionWithEndPoint:@”getGloballyUniqueIdentifier”];
```

#### 2.For POST methods
This method would get call whenever developer want to send extra parameters with endpoint
This call has method type ‘POST’

#### Method:
```obj-c
-(void)createSessionforCSIEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
```
#### How To Use:
```obj-c
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
apiHandler.delegate = self;
```

1.For Request CSI Registration:
```obj-c
[apiHandler createSessionforCSIEndPoint:@”requestCsiRegistration” withModelDictionary:requestDict]
```



Where requestDict Contains following Data:
{
"applicationClass": "string",                  //"mHealth DApp"
"cipherSpec": "string",                           //"ecdsa"
"csiGuid": "string",                                  //Global unique identifier received in previous call
"dateTime": "string",                              //timestamp,
"deviceId": "string",                                //Value shared by CSA app
"nonce": "string",
"publicClaims": [
{
// Use empty string as values, as DApp don't have user public claim data yet
"DateofBirth" : “”,
"FirstName" : “”,
"MiddleName" : “”,
"LastName" : “”,
"Gender": “”
}
],
"publicKey": "string",                              //keystring
"signature": "string"                                //signature
}

2.FetchPublicClaims:
```obj-c
[apiHandler createSessionforCSIEndPoint:@”fetchpublicClaims” withModelDictionary:requestDict]
```
Where requestDic following parameters

{
"cipher": "ecdsa",
"csiGuid": "string",                                     //DApp Csi
"dateTime": "string",
"desiredCsiGuid": "string",                        //CSI of CSA (shared by CSA)
"nonce": "string",
"signature": "string"
}



#### 3.Session auth Point
Developer need to call this method whenever he wants to send data in encoded string. This call has ‘POST’ method.

#### Method:
-(void)createSessionforAuthEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;

#### How to use:
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
apiHandler.delegate = self;

1.AuthCall
[apiHandler createSessionforAccessEndPoint:_endpoint withURLEncodedString:urlEncodedString];

This URL encode call have following has JWT with following parameters
JWT Header
{
"alg": "String",                 //ecdsa
"typ": "String"                //jwt
}
JWT Body
{
"iss" : "String",             //  Dapp CSI
"sub" : "String",           //  Dapp CSI
"aud" : "String",           //  URL of authorization server [<server>/vaca/auth]
"iat" : "String",             //  Time of token creation
"exp" : "String",           //  The token expiration time
"jti" : "String",              //  DApp CSI
"scope": "String",        //
"sta" : "String"
}
Signature
{
signature of jwt body sting
}

Final_assembly = base64Encodeof[JWTHeader.JWTBodyString.Signature]

final url call
body = "grant_type=authorization_code&assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&assertion="+finalAssembly



#### 4.Json data methods for permissions
This method will be used when input type is json objects

#### Method:
```obj-c
-(void)createSessionforPermissionEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
```
#### How to use:
```obj-c
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
apiHandler.delegate = self;
```

1.For write permission
```obj-c
[apiHandler createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];
```
Where endpoint = “writePermission”
And request dict contains following parameters:

{
"cipher": "string",              // ecdsa
"csiGuid": "string",            // CSI of DApp
"dateTime": "string",
"nonce": "string",
"permission": {                       // Permission details
"endTime": "string",            // Permission end time
"heartScope": {                    // Heart Scope Data
"accessType": "string",
"confidentialityScope": "string",
"permissionType": "string",
"resourceScope": "string",
"sensitivityScope": [
"string"
]
},
"permissionedCsiGuids": [
"string"                                           // CSI list of people user select to gran access
],
"startTime": "string",                     // Permission start time
"timeStamp": "string"                    // Time stamp
},
"signature": "string"                         // signature string signed by pk of DApp
}

2. For fetch Permissions Previously Granted By Me
```obj-c
[apiHandler createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];
```
Where endPoint = “fetchPermissionsPreviouslyGrantedByMe”
And requestDict contains following parameters :
{
cipher = ecdsa;     // ecdsa
csiGuid = "string";    // CSI of DApp
dateTime = "string";
nonce = "string";
signature = "string";         // signature string signed by pk of DApp
}

3. For Delete Permission
```obj-c
[apiHandler createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];
```
Where endPoint = “deletePermission”
And requestDict contains following parameters :
{
"cipher": "string",
"csiGuid": "string",
"dateTime": "string",
"nonce": "string",
"permissionedGuidBeingDeleted": "string",
"signature": "string"
}

4.Fetch permission given to me
```obj-c
[apiHandler createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];
```
Where endPoint = “deletePermission”
And requestDict contains following parameters :

{
cipher = ecdsa;     // ecdsa
csiGuid = "string";    // CSI of DApp
dateTime = "string";
nonce = "string";
signature = "string";         // signature string signed by pk of DApp
}


#### 5.For access End Point :

This method can be used for access call api

#### Method:
```obj-c
-(void)createSessionforAccessEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;
```

#### How to use:
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
apiHandler.delegate = self;

#### 6.For access Call:
```obj-c
[apiHandler createSessionforAccessEndPoint:_endpoint withURLEncodedString:urlEncodedString];
```

This URL encode call have following has JWT with following parameters
JWT Header
{
"kid": "String",                 //Dapp CSI
"alg": "String"                //ES256
}
JWT Body
{
"code" : "String",             //  Auth token from auth call
"iss" : "String",                 //  Dapp CSI
}
Signature
{
signature of jwt body string
}

Final_assembly = base64Encodeof[JWTHeader.JWTBodyString.Signature]

final url call
body = "grant_type=authorization_code&"+"code="+state.code(Auth token from auth call)+"&"+"client_assertion_type=urn%3Aietf%3Aparams%3Aoauth%3A"+"client-assertion-type%3Ajwt-bearer&"+"client_assertion="+finalAssembly


#### 7.FHIR Resource Consumption:

This method used for FHIR consumption of resource

#### Method:
```obj-c
-(void)createFHIRResourceConsumptionRequest:(NSString*)endPoint accessToken:(NSString*)accessToken;
```

#### How to Use:
```obj-c
mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
apiHandler.delegate = self
```
For FHIR consumption
```obj-c
[apiHandler createFHIRResourceConsumptionRequestWithAcessToken:accessStr];
```
Where  accessStr = accesstoken received from access call;










