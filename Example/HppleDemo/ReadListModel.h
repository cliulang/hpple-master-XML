//
//  ReadListModel.h
//  HppleDemo
//
//  Created by zero on 15/7/20.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    ReadPassion = 0,
    ReadJoke,
    ReadSkill
}ReadType;

@interface ReadListModel : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* url;
@end
