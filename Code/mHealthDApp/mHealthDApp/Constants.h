//
//  Constants.h
//  AAII_Project
//
//

#ifndef Constants_h
#define Constants_h

#define DEBUG_MODE

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%s (%d)> %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif


//#define Base_URL @"http://smoac.fhirblocks.io:8080/util/"
//#define CSI_Base_URL @"http://smoac.fhirblocks.io:8080/csi/"

//#define Base_URL @"http://52.40.243.158:8080/util/"
//#define CSI_Base_URL @"http://52.40.243.158:8080/csi/"

#define Base_URL @"http://smoac.fhirblocks.io:8080/util/"
#define CSI_Base_URL @"http://smoac.fhirblocks.io:8080/csi/"
#define Auth_Base_URL @"http://smoac.fhirblocks.io:8080/vaca/auth"
#define Access_Base_URL @"http://smoac.fhirblocks.io:8080/vaca/access"
#define Permission_Base_URL @"http://smoac.fhirblocks.io:8080/permission/"

//#define Base_URL @"http://10.0.0.202:9001/util/"
//#define CSI_Base_URL @"http://10.0.0.202:9001/csi/"
//#define Auth_Base_URL @"http://10.0.0.202:9001/vaca/auth"
//#define Permission_Base_URL @"http://10.0.0.202:9001/permission/"

#define AUTHORIZATION_TOKEN_LIFESPAN_IN_SECONDS 300
#define CAREGIVER @"caregivers"
#define PROVIDER @"providers"
#define FINALFAMILYDATAARRAY @"FinalFamilyDataArray"
#define COMPONENTS_SEPERATED_STRING  @"#"

#endif /* Constants_h */
