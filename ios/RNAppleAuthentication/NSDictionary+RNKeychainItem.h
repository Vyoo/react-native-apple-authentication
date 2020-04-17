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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RNKeychainItem)
/**
 *  Returns a previously stored dictionary from the KeyChain.
 *
 *  @param  key          NSString    The name of the dictionary. There can be multiple dictionaries stored in the KeyChain.
 *
 *  @return NSDictionary    A dictionary that has been stored in the Keychain, nil if no dictionary for the key and accessGroup exist.
 */
+ (NSDictionary *)objectFromKeychainWithKey:(NSString *)key;

/**
 *  Deletes a previously stored dictionary from the KeyChain.
 *
 *  @param  key          NSString    The name of the dictionary. There can be multiple dictionaries stored in the KeyChain.
 */
- (void)deleteObjectFromKeychainWithKey:(NSString *)key;

/**
 *  Save dictionary instance to the KeyChain. Any previously existing data with the same key and accessGroup will be overwritten.
 *
 *  @param  key          NSString    The name of the dictionary. There can be multiple dictionaries stored in the KeyChain.
 */
- (void)saveObjectFromKeychainWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
