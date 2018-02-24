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

#import "RMQSuspendResumeDispatcher.h"
#import "RMQErrors.h"

typedef NS_ENUM(NSUInteger, DispatcherState) {
    DispatcherStateOpen = 1,
    DispatcherStateClosedByClient,
    DispatcherStateClosedByServer,
};

@interface RMQSuspendResumeDispatcher ()
@property (nonatomic, readwrite) id<RMQChannel> channel;
@property (nonatomic, readwrite) id<RMQSender> sender;
@property (nonatomic, readwrite) RMQFramesetValidator *validator;
@property (nonatomic, readwrite) id<RMQLocalSerialQueue> commandQueue;
@property (nonatomic, readwrite) id<RMQLocalSerialQueue> enablementQueue;
@property (nonatomic, readwrite) NSNumber *enableDelay;
@property (nonatomic, readwrite) id<RMQConnectionDelegate> delegate;
@property (nonatomic, readwrite) DispatcherState state;
@property (nonatomic, readwrite) BOOL disabled;
@end

@implementation RMQSuspendResumeDispatcher

- (instancetype)initWithSender:(id<RMQSender>)sender
                  commandQueue:(id<RMQLocalSerialQueue>)commandQueue
               enablementQueue:(id<RMQLocalSerialQueue>)enablementQueue
                   enableDelay:(NSNumber *)enableDelay {
    self = [super init];
    if (self) {
        self.channel = nil;
        self.sender = sender;
        self.validator = [RMQFramesetValidator new];
        self.commandQueue = commandQueue;
        self.enablementQueue = enablementQueue;
        self.enableDelay = enableDelay;
        self.state = DispatcherStateOpen;
        self.disabled = NO;
    }
    return self;
}

- (instancetype)initWithSender:(id<RMQSender>)sender
                  commandQueue:(id<RMQLocalSerialQueue>)commandQueue {
    return [self initWithSender:sender commandQueue:commandQueue enablementQueue:nil enableDelay:@0];
}

- (void)activateWithChannel:(id<RMQChannel>)channel
                   delegate:(id<RMQConnectionDelegate>)delegate {
    self.channel = channel;
    self.delegate = delegate;
    [self.commandQueue resume];
}

- (void)blockingWaitOn:(Class)method {
    [self.commandQueue blockingEnqueue:^{
        [self processOutgoing:nil executeOrErr:^{
            [self.commandQueue suspend];
        }];
    }];

    [self.commandQueue blockingEnqueue:^{
        RMQFramesetValidationResult *result = [self.validator expect:method];
        if (result.error) {
            [self.delegate channel:self.channel error:result.error];
        }
    }];
}

- (void)sendSyncMethod:(id<RMQMethod>)method
     completionHandler:(void (^)(RMQFrameset *frameset))completionHandler {
    [self.commandQueue enqueue:^{
        [self processOutgoing:method executeOrErr:^{
            if ([self isClose:method]) {
                [self processClientClose];
            }

            RMQFrameset *outgoingFrameset = [[RMQFrameset alloc] initWithChannelNumber:self.channelNumber
                                                                                method:method];
            [self.commandQueue suspend];
            [self.sender sendFrameset:outgoingFrameset];
        }];
    }];

    [self.commandQueue enqueue:^{
        RMQFramesetValidationResult *result = [self.validator expect:method.syncResponse];
        if (self.channelIsOpen && result.error) {
            [self.delegate channel:self.channel error:result.error];
        } else if (self.channelIsOpen) {
            completionHandler(result.frameset);
        }
    }];
}

- (void)sendSyncMethod:(id<RMQMethod>)method {
    [self sendSyncMethod:method
       completionHandler:^(RMQFrameset *frameset) {}];
}

- (void)sendSyncMethodBlocking:(id<RMQMethod>)method {
    [self.commandQueue blockingEnqueue:^{
        [self processOutgoing:method executeOrErr:^{
            RMQFrameset *frameset = [[RMQFrameset alloc] initWithChannelNumber:self.channelNumber method:method];
            [self.commandQueue suspend];
            [self.sender sendFrameset:frameset];
        }];
    }];

    [self.commandQueue blockingEnqueue:^{
        RMQFramesetValidationResult *result = [self.validator expect:method.syncResponse];
        if (self.channelIsOpen && result.error) {
            [self.delegate channel:self.channel error:result.error];
        }
    }];
}

- (void)sendAsyncFrameset:(RMQFrameset *)frameset {
    [self.commandQueue enqueue:^{
        [self processOutgoing:frameset.method executeOrErr:^{
            [self.sender sendFrameset:frameset];
        }];
    }];
}

- (void)sendAsyncMethod:(id<RMQMethod>)method {
    [self sendAsyncFrameset:[[RMQFrameset alloc] initWithChannelNumber:self.channelNumber method:method]];
}

- (void)enqueue:(RMQOperation)operation {
    [self.commandQueue enqueue:operation];
}

- (void)disable {
    self.disabled = YES;
    [self.commandQueue suspend];
}

- (void)enable {
    [self.enablementQueue delayedBy:self.enableDelay enqueue:^{
        self.disabled = NO;
        [self.commandQueue resume];
    }];
}

- (void)handleFrameset:(RMQFrameset *)frameset {
    if (!self.channelAlreadyClosedByServer && [self isClose:frameset.method]) {
        [self processServerClose:(RMQChannelClose *)frameset.method];
    } else if (self.channelIsOpen) {
        [self.validator fulfill:frameset];
    }
    if (!self.disabled) {
        [self.commandQueue resume];
    }
}

# pragma mark - Private

- (void)processOutgoing:(id<RMQMethod>)method
           executeOrErr:(void (^)())operation {
    if (self.channelIsOpen) {
        operation();
    } else if (![self isClose:method]) {
        [self sendChannelClosedError];
    }
}

- (void)processClientClose {
    self.state = DispatcherStateClosedByClient;
}

- (void)processServerClose:(RMQChannelClose *)close {
    self.state = DispatcherStateClosedByServer;
    NSError *error = [NSError errorWithDomain:RMQErrorDomain
                                         code:close.replyCode.integerValue
                                     userInfo:@{NSLocalizedDescriptionKey: close.replyText.stringValue}];
    [self.delegate channel:self.channel error:error];
    [self.sender sendFrameset:[[RMQFrameset alloc] initWithChannelNumber:self.channelNumber
                                                                  method:[RMQChannelCloseOk new]]];
}

- (void)sendChannelClosedError {
    NSError *error = [NSError errorWithDomain:RMQErrorDomain
                                         code:RMQErrorChannelClosed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Cannot use channel after it has been closed."}];
    [self.delegate channel:self.channel error:error];
}

- (BOOL)channelIsOpen {
    return self.state == DispatcherStateOpen;
}

- (BOOL)channelAlreadyClosedByServer {
    return self.state == DispatcherStateClosedByServer;
}

- (BOOL)isClose:(id<RMQMethod>)method {
    return [method isKindOfClass:[RMQChannelClose class]];
}

- (NSNumber *)channelNumber {
    return self.channel.channelNumber;
}

@end
