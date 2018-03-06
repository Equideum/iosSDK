//
//  PermissionData.h
//  mHealthDAP
//
//

#import <Foundation/Foundation.h>

@interface PermissionData : NSObject<NSCoding>
@property(nonatomic,strong)NSString *startDate;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic)BOOL checked;
@property(nonatomic)int index;
@property(nonatomic,strong)NSString *userType;
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *LastName;

-(id)init;
@end
