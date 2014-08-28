//
//  UrlConnection.m
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import "UrlConnection.h"
#import "Constants.h"
#import "Data.h"

@implementation UrlConnection
{
    NSMutableData *myData;
    BOOL isError;
}
@synthesize delegate,serviceName;
@synthesize urlConnection;
@synthesize activity;
-(id)init
{
    if(self=[super init])
    {
        isError=NO;
    }
    return self;
}

-(void)openUrl:(NSString *)urlToOpen
{
    NSURL *myUrl = [NSURL URLWithString:urlToOpen];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    [myRequest setHTTPMethod:@"GET"];
    myData = [[NSMutableData alloc] initWithLength:0];
    NSURLConnection *myConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:YES];
    if(!myConnection)
    {
        NSLog(@"Error");
    }
    
}

-(void)postData:(NSDictionary *)dictionary searchType:(NSString *)type
{
     NSString *postStr=[NSString stringWithFormat:@"%@/%@/",AmgineAccessUrl,type];
      NSLog(@"value of Post Str=%@",postStr);
     myData = [[NSMutableData alloc] initWithLength:0];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:postStr]];
     [request setHTTPMethod:@"POST"];
     NSLog(@"Value of Json Dictionary=%@",dictionary);
     NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    if(jsonData)
    {
        NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        urlConnection=connection;
        if(!connection)
        {
            NSLog(@"Connection Failed");
        }
        else
        {
            NSLog(@"connection Success");
        }
    }
}

-(void)createNewUserType:(NSString *)type withKey:(NSString *)userStr
{
    NSString *postStr=[NSString stringWithFormat:@"%@/%@",AmgineAccessUrl,type];
    myData = [[NSMutableData alloc] initWithLength:0];
    NSString * key =userStr;
    NSLog(@"value of PostString :%@ and Key :%@",postStr,key);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:postStr]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[key dataUsingEncoding:NSUTF8StringEncoding]];
 //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection)
    {
        NSLog(@"Connection Failed");
    }

}
-(void)stopConnection:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isError=YES;
    [connection cancel];
    connection=nil;
}


#pragma mark Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     urlConnection=connection;
     NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
   
     NSInteger code = [httpResponse statusCode];
     NSLog(@"Description :%@",[NSHTTPURLResponse localizedStringForStatusCode:code]);
     NSLog(@"connection=%li",(long)code);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [myData setLength:0];
   if(code!=200)
   {
       if(delegate)
       {
           [delegate connectionFailedWithError:[NSHTTPURLResponse localizedStringForStatusCode:code] withService:self];
       }
       [self stopConnection:connection];
   }
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)imageData
{
    //connection Receive data-append in myData
    urlConnection=connection;
    [myData appendData:imageData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    urlConnection=connection;
    isError=YES;
    [self errorMessage:error];
     connection=nil;
    
}
-(void)errorMessage:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     if(delegate)
     {
            [delegate connectionFailedWithError:error.localizedDescription withService:self];
     }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   urlConnection=connection;
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isError=NO;
    if(delegate)
    {
        [delegate connectionDidFinishLoadingData:myData withService:self];
    }
    else
    {
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Value of Search Dictionary=%@",dictionary);
        [[Data sharedData]savePreBookingData:dictionary];
    }
 
    connection=nil;
}

-(void)dealloc
{
     isError=NO;
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
