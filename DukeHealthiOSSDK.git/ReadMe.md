## FhirBlocks SDK Test App

#### About FhirBlocks
FhirBlocks is a sovereign trust framework for healthcare applications. FhirBlocks enables qualified parties to establish trust across different actors, apps, and devices so that they may access broadly distributed "pools" of healthcare data, all while preserving data access permissions and chain of custody audit mechanisms. FhirBlocks is sovereign in the sense that no single commercial party controls the framework. Sovereignty is achieved with the FhirBlocks protocol design itself, the open-source approach to managing the technical development project, and the governance structure of the FhirBlocks Foundation.

#### Introduction

The goal of the FhirBlocks iOS SDK Test App is to help iOS developers understand the orchestration 
of REST services between the core elements of the FhirBlocks ecosystem. There are three main systems involved:

##### 1. FhirBlocks backend (FBC) 	
The heart of FhirBlocks, this hosts the block chain environment commonly referred to as the “FBC backend”. 
##### 2. Fast Health Interoperability Resources(FHIR) Server
A server that is compliant with the FHIR standard. This system stores the patient medical records and this can be referred to as the Electronic Health Records (EHR) system. The FHIR server trusts the token issued by the FBC backend. 
##### 3. Identity Provider (IdP) 
The main responsibility of this system is to authenticate and authorize users. The FBC backend trusts the IdP. In addition to these systems, the patient uses a mobile application (referred to as the client) protected by biometrics to access data stored by a healthcare provider on the FHIR server. 

##### Signing data with Json Web Tokens(JWTs) 
The communication between all the systems in the ecosystem is very secure. Data exchanged between the systems conforms to the Json Web Token (JWT) standard. The client exchanges a public key with the FBC backend and signs all claims with the private key. The FBC backend and the FHIR server verify the signature with this public key and this makes it very hard to tamper the data. The algorithm chosen to sign JWT claims is EC-256. 

#### Invoking FhirBlocks REST APIs 
The test app provides a facility to test the FhirBlocks REST APIs. The functions of the test app are as follows:  

##### 1. Ping 
With this function the test app pings the server and a successful response contains the version of the server.
```sh
GET https://poc-node-1.fhirblocks.io/smoac/util/ping
```
##### 2. Get Time
This function gets the time from the server. 
```sh
GET https://poc-node-1.fhirblocks.io/smoac/util/getTime
```

##### 3. Get Nodes
Get the different nodes in the FhirBlocks topology.
```sh
GET https://poc-node-1.fhirblocks.io/smoac/util/getTopology
```

##### 4. Get Institution
Get a list of participating organizations in FhirBlocks. Each organization has meta information about its FHIR conformance URL and the IdP URL.
```sh
GET https://poc-node-1.fhirblocks.io/smoac/util/organization
```

##### 5. Generate KeyPair
This function generates a Public and Private key pair based on EC-256. Once keys are generated, they are stored in a keychain of the app. This step is essential to communicate with the FBC backend.   

##### 6. Register Client with DCR
Register the current client (test app in this case) with FhirBlocks. The public key of the client is submitted to the server. Upon successful registration a client ID is issued. Dynamic Client Registration(DCR) is essential to proceed further. Refer to the logs for the exact payload and the response from the server.
```sh
POST https://mitre.fhirblocks.io:444/uma-server-webapp/register
```

##### 7. Verify crypto with spook
The key exchange can be verified by signing a sample message and passing this to the FBC backend. The FBC backend responds with a successful verification message asserting that the key exchange was successful.
```sh
POST https://poc-node-1.fhirblocks.io/smoac/test/securityTest
```

##### 8. Get FBC Eula
Get the End User License Agreement(EULA) for FhirBlocks with this function. There are two stages involved in getting the EULA. 
###### *Stage 1*
The URL to the EULA is stored in a DocumentReference resource on the FHIR server. The test app fetches a DocumentReference resource from the FHIR server.  
```sh
GET http://hapi.fhir.org/baseDstu3/DocumentReference

Response: 
{
  "resourceType": "DocumentReference",
  "id": "423764",
  "meta": {
    "versionId": "1",
    "lastUpdated": "2018-11-03T06:55:28.725+00:00"
  },
  "status": "current",
  "docStatus": "final",
  "description": "Sample EULA",
  "content": [
    {
      "attachment": {
        "language": "en-US",
        "url": "https://s3-us-west-2.amazonaws.com/fhirblocksdocs/fbc/v1/doc.html",
        "title": "EULA"
      }
    }
  ]
}
```
###### *Stage 2* 
The "content/attachment/url" section of the JSON response contains the URL to the EULA document. The EULA document is retrieved from the same:
```sh
GET https://s3-us-west-2.amazonaws.com/fhirblocksdocs/fbc/v1/doc.html
```

##### 9. Execute Oauth2 with IdP
The next function deals with fetching a bearer token from the OAuth 2.0 server. The IdPs fetched from the *"Get Institution"* function is displayed. The user can choose a real IdP (Ex: Duke RS Test) or a mock IdP (Apollo). 

###### *Working with a Demo IdP*
A demo IdP has been setup to understand the interaction between the client, the IdP server, the FBC backend and a FHIR server. The FHIR server in this case is the open source HAPI FHIR server http://hapi.fhir.org/.  The name assigned to the demo IdP is “Apollo”. 
The credentials of the demo user are:  
      <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>UserName:</b> abc (lowercase)</p>
      <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Password:</b> 123</p> 
###### Demo data 
The HAPI FHIR server is an open source server that offers to store FHIR resources. But, this server doesn’t retain data permanently and is purged frequently. Therefore, the data must be inserted into the server before the End User License Agreement (EULA) is reviewed and the Consent and Provenance resources are stored.  The test App inserts a sample “Patient” and “DocumentReference” resource conforming to the profiles mentioned above.  The activity diagram below illustrates the case when demo data will be inserted into the system.
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="FBC_MockIdP_ActivityDiagram.png" width="500" height="600" alt="Working with a mock IdP"></p>

###### *Working with an actual IdP*
The test app can work with an actual IdP too (Ex: Duke Resource Server). This case is straightforward, the IdP is rendered in the Webview and once authentication happens the FHIR Identifier is fetched by the app from the FBC backend and this is then used to create a Consent and Provenance record in the FHIR resource server. 

###### Note: The Authorize/Get token will succeed only with an actual IdP.

##### 9. Authorize/Get token

###### Get the FHIR Identifier
Get the FHIR identifier of the patient resource from the FBC backend. This is required for further actions such as creating a consent or a provenance record. A JWT signed by the private key is created with the claim *command* set with the value *"getFhirIdentifier*".
```sh
GET https://poc-node-1.fhirblocks.io/smoac/csi/signedJwtMessage
```
Once the FHIR identifier is fetched, the client must initiate and finish the assertion with the backend.

###### Begin Assertion
The FHIR identifier is passed to initiate assertion with the FBC backend. 
```sh
GET https://poc-node-1.fhirblocks.io/smoac/oauth2/beginGetAssertion
```

###### Finish Assertion
The test app signs the assertion response and then posts it to the FBC backend to finish the assertion. An authcode is returned in the response. 
```sh
POST https://poc-node-1.fhirblocks.io/smoac/oauth2/finishGetAssertion
```

###### Get AuthToken
Once the assertion is completed successfully, post the authcode to the server to get the oauth token from the FBC backend.
```sh
POST  https://poc-node-1.fhirblocks.io/smoac/oauth2/token
```

##### 10. Get Patient Resource
This function lets the test app get the FHIR identifier of the patient. It presents the bearer token in the *Authorization* header to the FHIR resource server to retrieve the *Patient* resource. 
```sh
GET http://hapi.fhir.org/baseDstu3/Patient/
```

##### 11. Write FBC Consent
This function lets the test app create a *Consent* resource on the FHIR server. The bearer token must be presented with the *Authorization* header. 
```sh
POST http://hapi.fhir.org/baseDstu3/Consent
```

##### 12. Write Provenance
The *Consent* resource is then embedded in the *Provenance* resource and then posted to the server.
```sh
POST http://hapi.fhir.org/baseDstu3/Provenance
```
 
##### 13. Write FBC Audit
This function allows the test app to post an audit event to the FBC server. This mimics an acceptance or rejection of the consent record.
```sh
POST  https://poc-node-1.fhirblocks.io/smoac/audit/signedResource
```

#### Note: Refer to the logs for the exact payloads for the functions listed above.  










