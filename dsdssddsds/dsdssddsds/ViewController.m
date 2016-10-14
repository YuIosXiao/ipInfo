//
//  ViewController.m
//  dsdssddsds
//
//  Created by apple on 2016/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    NSString * ip = [self getIPAddress];
    
    
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
    NSString *ipString = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    [self texst];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"e62bb53a8c4230b19f6c134d993451b17e8e1285" forHTTPHeaderField:@"Token"];
    
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    NSDictionary * dic = @{@"addr":ipString};
    [manager GET:@"http://ipapi.ipip.net/find" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}


- (void) texst{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSError *error = nil;
        NSString *ipString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"fetch WAN IP Address failed:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *httpUrl = @"http://ip.taobao.com/service/getIpInfo.php";
                NSString * httpArg = [NSString stringWithFormat:@"ip=%@",ipString];
                NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
                //                void (^holdBlock)(id response, NSError *error) = [handler copy];
                
                NSURL *url = [NSURL URLWithString: urlStr];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
                [request setHTTPMethod: @"GET"];
                [request addValue: @"您自己的apikey" forHTTPHeaderField: @"apikey"];
                [NSURLConnection sendAsynchronousRequest: request
                                                   queue: [NSOperationQueue mainQueue]
                                       completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                           if (error) {
                                               NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                               //                                               holdBlock(nil, error);
                                           } else {
                                               NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                               NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                               NSLog(@"HttpResponseBody %@",responseString);
                                               //                                               holdBlock(responseString, nil);
                                           }
                                       }];
            });
        }
    });
}



- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
