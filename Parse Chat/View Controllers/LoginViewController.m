//
//  LoginViewController.m
//  Parse Chat
//
//  Created by Megan Miller on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerUserButton;
@property (weak, nonatomic) IBOutlet UIButton *loginUserButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)registerUser:(id)sender {
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Text Field(s)"
                                                                       message:@"Please fill in username and password."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            return;
        }];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
            
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
            }
        }];
    }
}

- (IBAction)loginUser:(id)sender {
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Text Field(s)"
                                                                       message:@"Please fill in username and password."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            return;
        }];
    } else {
        NSString *username = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"chatSegue" sender:self];
            }
        }];
    }
}

@end
