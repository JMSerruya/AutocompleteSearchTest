//
//  JMSViewController.h
//  AutocompleteSearchTest
//
//  Created by Juan Manuel Serruya on 3/31/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *fromTextField;
@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, retain) NSArray *JSONData;


@end
