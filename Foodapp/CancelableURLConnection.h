#import <Foundation/Foundation.h>


// NSURLConnection.sendSynchronousRequest does not offer a option to cancel the request, but has a nice
// API otherwise. CancelableURLConnetion uses NSURLConnection's async methods to make a cancelable alternative
@interface CancelableURLConnection : NSObject {
@private
	NSURLConnection *urlConnection;
    NSURLRequest *originalRequest;
	NSMutableData *requestData;
	NSURLResponse *requestResponse;
    NSURL *requestRedirectURL;
    BOOL redirectPOST;
	NSError *requestError;
	dispatch_semaphore_t requestComplete;
}

@property (nonatomic, assign) BOOL redirectPOST;

- (NSData *)sendCancelableSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response redirectedURL:(NSURL **)redirectedURL error:(NSError **)error;
- (void)cancel;

@end
