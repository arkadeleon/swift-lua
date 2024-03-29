//
//  LuaContext.h
//  Givit
//
//  Created by Sean Meiners on 2013/11/19.
//
//

#import <Foundation/Foundation.h>

#define STRINGIZE_LUA(...) #__VA_ARGS__
#define STRINGIZE2_LUA(...) STRINGIZE_LUA(__VA_ARGS__)

/**
 this is the class overview
 */

#define LUA_STRING(...) @ STRINGIZE2_LUA(__VA_ARGS__)

/**
 `LuaErrorDomain`
 */
extern NSString *const LuaErrorDomain;

/**
 These are the only valid values for [NSError code] when [NSError domain] is set to `LuaErrorDomain`
 */
typedef NS_ENUM(NSUInteger, LuaErrorCode) {
    /** No error, this should never be seen */
    LuaError_Ok = 0,
    /** Maps to LUA_YIELD */
    LuaError_Yield,
    /** Maps to LUA_ERRRUN - a runtime error. */
    LuaError_Runtime,
    /** Maps to LUA_ERRSYNTAX - syntax error during precompilation */
    LuaError_Syntax,
    /** Maps to LUA_ERRMEM - memory allocation error. */
    LuaError_Memory,
    /** Maps to LUA_ERRGCMM - error while running a __gc metamethod. (This error typically has no relation with the function being called. It is generated by the garbage collector.) */
    LuaError_GarbageCollector,
    /** Maps to LUA_ERRERR - error while running the message handler. */
    LuaError_MessageHandler,
    /** Returned when [LuaContext parseURL:error:] is called with a non-'file://' URL or [LuaContext call:with:error:] is called for a function that does not exist in the context */
    LuaError_Invalid
};

/**
 `LuaContext` contains all the methods needed to parse & call Lua scripts. See the top-level overview for examples.

 The call:with:error:, objectForKeyedSubscript:, and setObject:forKeyedSubscript: methods will automatically translate
 between NSNull, NSNumber, NSString, NSArray, and NSDictionary types and their Lua equivelents. If you need to pass
 other object types into the context, you must use the LuaExport protocol.

 The context will also translate between NSValue types containing CGPoint, CGSize, CGRect, CGAffineTransform, and CATransform3D structs.
 */
@interface LuaContext : NSObject

- (BOOL)load:(NSData*)data error:(out NSError**)error;

/**
 @param script A Lua script to be parsed and added to this context
 @param error will only be set if this method returns `NO`
 @return `YES` on success, otherwise `NO` and `error` will be set
 */
- (BOOL)parse:(NSString*)script error:(out NSError**)error;
/**
 @param url The path to a Lua script to be parsed and added to this context. Currently only accepts URLs with the scheme 'file://'
 @param error will only be set if this method returns `NO`
 @return `YES` on success, otherwise `NO` and `error` will be set
 */
- (BOOL)parseURL:(NSURL*)url error:(out NSError**)error;
/**
 @param name The name of the Lua function that already exists in this context to call.
 @param args Arguments to pass to the function. Any non-specified args will be passed as if they were set to [NSNull null]
 @param error will only be set if this method returns `NO`
 @return `YES` on success, otherwise `NO` and `error` will be set
 */
- (id)call:(NSString*)name with:(NSArray*)args error:(out NSError**)error;

/**
 @param key The name of a Lua variable to retreive from this context
 @return The value of `key` or nil if `key` is does not exist
 */
- (id)objectForKeyedSubscript:(id)key;
/**
 @param key The name of a Lua variable to set in this context
 @param object The value to set `key` to in this context
 */
- (void)setObject:(id)object forKeyedSubscript:(NSObject <NSCopying> *)key;

@end
