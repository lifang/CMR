#import "NSDictionary-MutableDeeepCopy.h"

@implementation NSDictionary (MutableDeepCopy)

//创建深层可变副本
-(NSMutableDictionary *)mutableDeepCopy{
	NSMutableDictionary *returnDict = [[NSMutableDictionary alloc]
									   initWithCapacity:[self count]];
	NSArray *keys = [self allKeys];
	for(id key in keys){
		id oneValue = [self valueForKey:key];
		id oneCopy = nil;
        
		if([oneValue respondsToSelector:@selector(mutableDeepCopy)])
			oneCopy = [oneValue mutableDeepCopy];
		else if([oneValue respondsToSelector:@selector(mutableCopy)])
			oneCopy = [oneValue mutableCopy];
		if(oneCopy == nil)
			oneCopy = [oneValue copy];
		[returnDict setValue:oneCopy forKey:key];
	}
	return returnDict;
}

@end