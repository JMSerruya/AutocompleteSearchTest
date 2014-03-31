//
//  JMSAPIWrapper.m
//  AutocompleteSearchTest
//
//  Created by Juan Manuel Serruya on 3/31/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSAPIWrapper.h"
#import "AFNetworking.h"

@implementation JMSAPIWrapper
static JMSAPIWrapper *apiInstance = nil;

+(id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (apiInstance == nil) {
            apiInstance = [[self alloc] init];
        }
    });
    return apiInstance;
}

#pragma mark -

- (void)requestSuggestionsForTerm:(NSString *)term callback:(CompletionBlock)callback
{
    //Hardcoded location to DE
    NSString *request = [NSString stringWithFormat:@"https://api.goeuro.com/api/v2/position/suggest/de/%@", term];
    [self performRequest:request parameters:nil callback:^(BOOL success, NSData *response, NSError *error) {
        callback(success, response, error);
    }];

}

#pragma mark -

-(void)performRequest:(NSString *)path parameters:(NSDictionary *)params callback:(CompletionBlock)callback
{
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.securityPolicy.allowInvalidCertificates = YES;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback != nil) callback(TRUE,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @try {
            if (operation.response.statusCode == 404) {
                NSLog(@"Page doesn't exist");
            }
        } @catch (NSException *ex) {

        }

        if (callback != nil) callback(FALSE,nil,error);
    }];
    [operation start];
}
@end
