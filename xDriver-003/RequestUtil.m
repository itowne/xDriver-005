//
//  RequestUtil.m
//  xDriver-003
//
//  Created by 林国强 on 15/7/16.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "RequestUtil.h"

@implementation RequestUtil

+(NSURL *)getUrl{
    return [NSURL URLWithString:@"http://115.28.93.210/xDriver/action.php"];
}

+(void) saveMileToServer:(MileModel *)model{
    
    NSString *msg = [NSString stringWithFormat:@"type=1&start_mile=%@&end_mile=%@&start_time=%@&end_time=%@", model.startMile, model.endMile, model.startTime, model.endTime];
    NSData *postData = [msg dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[self getUrl]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    //    [request setValue:@"Hello World!" forKey:@"msg"];
    
    //    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    //    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"save %ld failure ... ", model.mileId);
        }else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"response from server is %@", result);
        }
    }];
}

+(void) didOilToServer:(OilModel *)model{
    NSString *msg = [NSString stringWithFormat:@"type=2&current_mile=%@&left_time=%@&oil_price=%@&oil_time=%@",
                     model.currentMile, model.leftMile, model.oilPrice, model.oilTime];
    NSData *postData = [msg dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[self getUrl]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    //    [request setValue:@"Hello World!" forKey:@"msg"];
    
    //    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    //    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"save %ld failure ... ", model.oilId);
        }else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"response from server is %@", result);
        }
    }];
}

@end
