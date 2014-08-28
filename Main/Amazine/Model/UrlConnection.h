//
//  UrlConnection.h
//  Amazine
//
//  Created by Amgine on 11/06/14.
//  Copyright (c) 2014 Amgine. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol UrlConnectionDelegate ;

@interface UrlConnection : NSObject
{
    
}
-(void)openUrl:(NSString *)urlToOpen;
-(void)postData:(NSDictionary *)dictionary searchType:(NSString *)type;
-(void)createNewUserType:(NSString *)type withKey:(NSString *)userStr;
-(void)stopConnection:(NSURLConnection *)connection;
//-(void)changeAlternative:(NSDictionary *)dictionary searchType:(NSString *)type;
@property NSString *serviceName;
@property UIActivityIndicatorView *activity;
@property id<UrlConnectionDelegate>delegate;
@property  NSURLConnection *urlConnection;

@end

@protocol UrlConnectionDelegate <NSObject>
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection;
-(void)connectionDidFinishLoadingData:(NSData *)data withService:(UrlConnection *)connection;



@end



