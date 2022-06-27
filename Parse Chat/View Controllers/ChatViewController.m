//
//  ChatViewController.m
//  Parse Chat
//
//  Created by Megan Miller on 6/27/22.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self refreshData];
    [self.tableView reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshData) userInfo:nil repeats:true];
}

- (void)refreshData {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully fetched messages");
            self.messages = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to fetch messages: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    PFObject *chatMessage = self.messages[indexPath.row];
    cell.messageLabel.text = chatMessage[@"text"];
    return cell;
}

- (IBAction)sendMessage:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    chatMessage[@"text"] = self.messageField.text;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.messageField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

@end
