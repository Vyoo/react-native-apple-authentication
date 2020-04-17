//
/**
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "NSDictionary+RNKeychainItem.h"

@implementation NSDictionary (RNKeychainItem)

- (void)saveObjectFromKeychainWithKey:(NSString *)key
{
    NSData *serializedDictionary = [NSKeyedArchiver archivedDataWithRootObject:self];
    [self deleteObjectFromKeychainWithKey:key];
    NSDictionary *storageQuery = @{(__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecValueData: serializedDictionary,
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
    };
    OSStatus status = SecItemAdd ((__bridge CFDictionaryRef)storageQuery, nil);
    if (status != noErr)
    {
        NSLog (@"%d %@", (int)status, @"Couldn't save to Keychain.");
    }
}


+ (NSDictionary *)objectFromKeychainWithKey:(NSString *)key
{
    // setup keychain query properties
    NSDictionary *readQuery = @{
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecReturnData: (id)kCFBooleanTrue,
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword
    };

    CFDataRef serializedDictionary = NULL;
    OSStatus status = SecItemCopyMatching ((__bridge CFDictionaryRef)readQuery, (CFTypeRef *)&serializedDictionary);
    if (status == noErr)
    {
        // deserialize dictionary
        NSData *data = (__bridge NSData *)serializedDictionary;
        NSDictionary *storedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return storedDictionary;
    }
    else
    {
        NSLog (@"%d %@", (int)status, @"Couldn't read from Keychain.");
        return nil;
    }
}


- (void)deleteObjectFromKeychainWithKey:(NSString *)key
{
    // setup keychain query properties
    NSDictionary *deletableItemsQuery = @{
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitAll,
        (__bridge id)kSecReturnAttributes: (id)kCFBooleanTrue
    };
    CFArrayRef itemList = nil;
    OSStatus status = SecItemCopyMatching ((__bridge CFDictionaryRef)deletableItemsQuery, (CFTypeRef *)&itemList);
    // each item in the array is a dictionary
    NSArray *itemListArray = (__bridge NSArray *)itemList;
    for (NSDictionary *item in itemListArray)
    {
        NSMutableDictionary *deleteQuery = [item mutableCopy];
        [deleteQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        // do delete
        status = SecItemDelete ((__bridge CFDictionaryRef)deleteQuery);
        if (status != noErr)
        {
            NSLog (@"%d %@", (int)status, @"Couldn't delete from Keychain.");
        }
    }
}
@end
    
