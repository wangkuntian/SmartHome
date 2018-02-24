// This source code is dual-licensed under the Mozilla Public License ("MPL"),
// version 1.1 and the Apache License ("ASL"), version 2.0.
//
// The ASL v2.0:
//
// ---------------------------------------------------------------------------
// Copyright 2016 Pivotal Software, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ---------------------------------------------------------------------------
//
// The MPL v1.1:
//
// ---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is RabbitMQ
//
// The Initial Developer of the Original Code is Pivotal Software, Inc.
// All Rights Reserved.
//
// Alternatively, the contents of this file may be used under the terms
// of the Apache Standard license (the "ASL License"), in which case the
// provisions of the ASL License are applicable instead of those
// above. If you wish to allow use of your version of this file only
// under the terms of the ASL License and not to allow others to use
// your version of this file under the MPL, indicate your decision by
// deleting the provisions above and replace them with the notice and
// other provisions required by the ASL License. If you do not delete
// the provisions above, a recipient may use your version of this file
// under either the MPL or the ASL License.
// ---------------------------------------------------------------------------

#import "RMQMessage.h"

@interface RMQMessage ()
@property (nonatomic, readwrite) NSData *body;
@property (nonatomic, readwrite) NSString *consumerTag;
@property (nonatomic, readwrite) NSNumber *deliveryTag;
@property (nonatomic, readwrite) BOOL isRedelivered;
@property (nonatomic, readwrite) NSString *exchangeName;
@property (nonatomic, readwrite) NSString *routingKey;
@property (nonatomic, readwrite) NSArray *properties;
@end

@implementation RMQMessage

- (instancetype)initWithBody:(NSData *)body
                 consumerTag:(NSString *)consumerTag
                 deliveryTag:(NSNumber *)deliveryTag
                 redelivered:(BOOL)isRedelivered
                exchangeName:(NSString *)exchangeName
                  routingKey:(NSString *)routingKey
                  properties:(NSArray<RMQValue<RMQBasicValue> *> *)properties {
    self = [super init];
    if (self) {
        self.body = body;
        self.consumerTag = consumerTag;
        self.deliveryTag = deliveryTag;
        self.isRedelivered = isRedelivered;
        self.exchangeName = exchangeName;
        self.routingKey = routingKey;
        self.properties = properties;
    }
    return self;
}

- (NSString *)appID {
    return ((RMQBasicAppId *)[self objForClass:[RMQBasicAppId class]]).stringValue;
}

- (NSString *)contentType {
    return ((RMQBasicContentType *)[self objForClass:[RMQBasicContentType class]]).stringValue;
}

- (NSNumber *)priority {
    return @(((RMQBasicPriority *)[self objForClass:[RMQBasicPriority class]]).integerValue);
}

- (NSString *)messageType {
    return ((RMQBasicType *)[self objForClass:[RMQBasicType class]]).stringValue;
}

- (NSDictionary *)headers {
    return ((RMQBasicHeaders *)[self objForClass:[RMQBasicHeaders class]]).dictionaryValue;
}

- (NSDate *)timestamp {
    return ((RMQBasicTimestamp *)[self objForClass:[RMQBasicTimestamp class]]).dateValue;
}

- (NSString *)replyTo {
    return ((RMQBasicReplyTo *)[self objForClass:[RMQBasicReplyTo class]]).stringValue;
}

- (NSString *)correlationID {
    return ((RMQBasicCorrelationId *)[self objForClass:[RMQBasicCorrelationId class]]).stringValue;
}

- (NSString *)messageID {
    return ((RMQBasicMessageId *)[self objForClass:[RMQBasicMessageId class]]).stringValue;
}

#pragma mark - Private

- (NSDate *)objForClass:(Class)klass {
    for (id obj in self.properties) {
        if ([obj isKindOfClass:klass]) {
            return obj;
        }
    }
    return nil;
}

@end
