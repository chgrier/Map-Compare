//
//  MyAnnotation.m
//  MapBox
//
//  Created by Charles Grier on 6/3/15.
//  Copyright (c) 2015 Grier Mobile Development. All rights reserved.
//
// Annotation for future use in project
#import "MyAnnotation.h"

@interface MyAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@end

@implementation MyAnnotation

// implement required delegate

+(instancetype)annotationWithLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    return [[self alloc] initWithLocation:coordinate title:title subtitle:subtitle];
}

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    if ((self = [super init])) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
}

@end
