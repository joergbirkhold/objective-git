//
//  GTSignature.m
//  ObjectiveGitFramework
//
//  Created by Timothy Clem on 2/22/11.
//
//  The MIT License
//
//  Copyright (c) 2011 Tim Clem
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "GTSignature.h"
#import "NSDate+GTTimeAdditions.h"

@implementation GTSignature

#pragma mark Lifecycle

- (void)dealloc {
	if (_git_signature != NULL) git_signature_free(_git_signature);
}

- (id)initWithGitSignature:(const git_signature *)git_signature {
	NSParameterAssert(git_signature != NULL);

	self = [super init];
	if (self == nil) return nil;

	_git_signature = git_signature_dup(git_signature);

	return self;
}

- (id)initWithName:(NSString *)name email:(NSString *)email time:(NSDate *)time {
	NSParameterAssert(name != nil);
	NSParameterAssert(email != nil);

	self = [super init];
	if (self == nil) return nil;

	git_time gitTime = [time gt_gitTimeUsingTimeZone:nil];
	int status = git_signature_new(&_git_signature, name.UTF8String, email.UTF8String, gitTime.time, gitTime.offset);
	if (status != GIT_OK) return nil;

	return self;
}

#pragma mark NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p> name: %@, email: %@, time: %@", self.class, self, self.name, self.email, self.time];
}

#pragma mark Properties 

- (NSString *)name {
	return @(self.git_signature->name);
}

- (NSString *)email {
	return @(self.git_signature->email);
}

- (NSDate *)time {
	return [NSDate gt_dateFromGitTime:self.git_signature->when];
}

- (NSTimeZone *)timeZone {
	return [NSTimeZone gt_timeZoneFromGitTime:self.git_signature->when];
}

@end
