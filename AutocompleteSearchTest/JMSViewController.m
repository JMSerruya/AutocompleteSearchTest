//
//  JMSViewController.m
//  AutocompleteSearchTest
//
//  Created by Juan Manuel Serruya on 3/31/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSViewController.h"
#import "JMSAPIWrapper.h"

@interface JMSViewController ()

@end

@implementation JMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fromTextField.delegate = self;
    self.toTextField.delegate = self;
    self.isSearchingFrom = YES;
	self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(self.fromTextField.frame.origin.x, self.fromTextField.frame.origin.y + 30, 280, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    [self.view addSubview:self.autocompleteTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchTouchInside:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Search is not implemented yet!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil, nil];
    [alert show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.fromTextField && self.isSearchingFrom == NO) {
        self.isSearchingFrom = YES;
        [self updateAutoCompleteTableView];
    } else if (textField == self.toTextField && self.isSearchingFrom == YES) {
        self.isSearchingFrom = NO;
        [self updateAutoCompleteTableView];
    }
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    if ([substring length] > 2) {
        [self searchAutocompleteEntriesWithSubstring:substring];
    } else {
        [self.autocompleteTableView setHidden:YES];
        self.JSONData = nil;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [[JMSAPIWrapper instance] requestSuggestionsForTerm:substring callback:^(BOOL success, NSData *response, NSError *error) {
        self.JSONData = (NSArray*)[(NSDictionary*)response objectForKey:@"results"];
        [self.autocompleteTableView reloadData];
        [self.autocompleteTableView setHidden:NO];
    }];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.JSONData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    NSDictionary *city = [self.JSONData objectAtIndex:indexPath.row];
    cell.textLabel.text = [city objectForKey:@"name"];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *targetTextField = self.isSearchingFrom ? self.fromTextField : self.toTextField;
    targetTextField.text = selectedCell.textLabel.text;
    [targetTextField resignFirstResponder];
    [self.autocompleteTableView setHidden:YES];
    //[self goPressed];
}

- (void)updateAutoCompleteTableView{
    if (self.isSearchingFrom) {
        self.autocompleteTableView.frame = CGRectMake(self.fromTextField.frame.origin.x, self.fromTextField.frame.origin.y + 30, 280, 120);
    } else {
        self.autocompleteTableView.frame = CGRectMake(self.toTextField.frame.origin.x, self.toTextField.frame.origin.y + 30, 280, 120);
    }
    self.autocompleteTableView.hidden = YES;
}


@end
