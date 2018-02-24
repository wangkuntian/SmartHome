#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RMQAllocatedChannel.h"
#import "RMQBasicProperties+MergeDefaults.h"
#import "RMQBasicProperties.h"
#import "RMQChannel.h"
#import "RMQChannelAllocator.h"
#import "RMQClient.h"
#import "RMQClock.h"
#import "RMQConfirmations.h"
#import "RMQConfirmationTransaction.h"
#import "RMQConnection.h"
#import "RMQConnectionConfig.h"
#import "RMQConnectionDelegate.h"
#import "RMQConnectionDelegateLogger.h"
#import "RMQConnectionRecover.h"
#import "RMQConnectionRecovery.h"
#import "RMQConsumer.h"
#import "RMQConsumerHandlers.h"
#import "RMQDispatcher.h"
#import "RMQErrors.h"
#import "RMQExchange.h"
#import "RMQFrame.h"
#import "RMQFrameHandler.h"
#import "RMQFrameset.h"
#import "RMQFramesetValidationResult.h"
#import "RMQFramesetValidator.h"
#import "RMQGCDHeartbeatSender.h"
#import "RMQGCDSerialQueue.h"
#import "RMQHandshaker.h"
#import "RMQHeartbeat.h"
#import "RMQHeartbeatSender.h"
#import "RMQLocalSerialQueue.h"
#import "RMQMessage.h"
#import "RMQMethodDecoder.h"
#import "RMQMethodMap.h"
#import "RMQMethods+Convenience.h"
#import "RMQMethods.h"
#import "RMQMultipleChannelAllocator.h"
#import "RMQNameGenerator.h"
#import "RMQParser.h"
#import "RMQPKCS12CertificateConverter.h"
#import "RMQProcessInfoNameGenerator.h"
#import "RMQProtocolHeader.h"
#import "RMQQueue.h"
#import "RMQQueuingConnectionDelegateProxy.h"
#import "RMQReader.h"
#import "RMQSemaphoreWaiter.h"
#import "RMQSemaphoreWaiterFactory.h"
#import "RMQSender.h"
#import "RMQStarter.h"
#import "RMQSuspendResumeDispatcher.h"
#import "RMQSynchronizedMutableDictionary.h"
#import "RMQTable.h"
#import "RMQTCPSocketTransport.h"
#import "RMQTickingClock.h"
#import "RMQTLSOptions.h"
#import "RMQTransactionalConfirmations.h"
#import "RMQTransport.h"
#import "RMQTransportDelegate.h"
#import "RMQUnallocatedChannel.h"
#import "RMQURI.h"
#import "RMQValues.h"
#import "RMQWaiter.h"
#import "RMQWaiterFactory.h"

FOUNDATION_EXPORT double RMQClientVersionNumber;
FOUNDATION_EXPORT const unsigned char RMQClientVersionString[];

