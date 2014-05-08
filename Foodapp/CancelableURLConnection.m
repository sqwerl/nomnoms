#import "CancelableURLConnection.h"

// required only for CZ_TEST_REDIRECT_HEADER
//#include "CZDefines.h"

@interface NSURLRequest (CancelableURLConnection)
+ (NSURLRequest *)requestWithURLRequest:(NSURLRequest *)request repostingDataFrom:(NSURLRequest *)originalRequest;
@end

@implementation NSURLRequest (CancelableURLConnection)
+ (NSURLRequest *)requestWithURLRequest:(NSURLRequest *)request repostingDataFrom:(NSURLRequest *)originalRequest
{
    // copy primary request
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[request URL]
                                                               cachePolicy:[request cachePolicy]
                                                           timeoutInterval:[request timeoutInterval]];
    [postRequest setHTTPShouldHandleCookies:NO];
    [postRequest setHTTPShouldUsePipelining:[request HTTPShouldUsePipelining]];
    [postRequest setMainDocumentURL:[request mainDocumentURL]];
    [postRequest setNetworkServiceType:[request networkServiceType]];

    // supplement with method and body from original request
    [postRequest setHTTPMethod:[originalRequest HTTPMethod]];
    [postRequest setHTTPBody:[originalRequest HTTPBody]];

    NSDictionary *requestHeaders = [request allHTTPHeaderFields];
    for (NSString *header in requestHeaders) {
//        if (![header isEqualToString:CZ_TEST_REDIRECT_HEADER]) // avoid redirect loop
        [postRequest setValue:[requestHeaders objectForKey:header] forHTTPHeaderField:header];
    }

    return postRequest;
}
@end

@implementation CancelableURLConnection

@synthesize redirectPOST;

- (NSData *)sendCancelableSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response redirectedURL:(NSURL **)redirectedURL error:(NSError **)error {
    originalRequest = request;
	requestData = [NSMutableData dataWithCapacity:0];
	requestComplete = dispatch_semaphore_create(0);
	
	urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];

	// must start request on main thread, as it's the only one that: a) sticks around, and b) has a runloop
	// otherwise, our delegate will never get called
	dispatch_async(dispatch_get_main_queue(), ^{
		[urlConnection start];
	});	
	
	dispatch_semaphore_wait(requestComplete, DISPATCH_TIME_FOREVER);
//	dispatch_release(requestComplete);

    originalRequest = nil;

    if (response != NULL)
        *response = requestResponse;

	if (redirectedURL != NULL)
        *redirectedURL = requestRedirectURL;

	if (error != NULL)
		*error = requestError;

    requestRedirectURL = nil;

    requestError = nil;

	return requestData;
}


/* The following code enables self-signed SSL certificates.
 * This is only for use on non-production builds. Production builds must have "real" certificates
 */
#ifdef TARGET_JASPER
// tell URLConnection that we want to look at authentication challenges for NSURLAuthenticationMethodServerTrust
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// tell NSURLConnection that self-signed certs are OK
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([[challenge.protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	} else {
		[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	}
}
#endif

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[requestData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	requestResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	dispatch_semaphore_signal(requestComplete);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	requestError = error;
	dispatch_semaphore_signal(requestComplete);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *redirectRequest = request;

    if (redirectResponse != nil) {
        // if the original request was a POST, morph the HTTP standard GET redirect back to a POST to the new URL.
        if (redirectPOST && [[originalRequest HTTPMethod] isEqualToString:@"POST"]) {
            redirectRequest = [NSURLRequest requestWithURLRequest:request repostingDataFrom:originalRequest];
        }

        // record the redirect URL for the caller
        requestRedirectURL = [request URL];
    }

    return redirectRequest;
}

- (void)cancel {
	// cancel request
	[urlConnection cancel];

	// clear all results (may have partial results)
	requestData = nil;
	if (requestResponse != nil) {
		requestResponse = nil;
	}

	if (requestRedirectURL != nil) {
		requestRedirectURL = nil;
	}

    // report cancellation to client
    requestError = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];

	// let function return
	dispatch_semaphore_signal(requestComplete);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	if (originalRequest.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData)
		return nil;
	else
		return cachedResponse;
}

@end
