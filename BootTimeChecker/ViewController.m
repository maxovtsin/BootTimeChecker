//
//  ViewController.m
//  BootTimeChecker
//
//  Created by maxovtsin on 28/12/2019.
//  Copyright © 2019 maxovtsin. All rights reserved.
//

#import "ViewController.h"
#include <sys/sysctl.h>

typedef struct timeval timeval_t;

timeval_t kern_boottime() {
  struct timeval boottime;
  int mib[2] = {CTL_KERN, KERN_BOOTTIME};
  size_t size = sizeof(boottime);
  if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
    return boottime;
  }
  return (timeval_t){ .tv_sec = 0, .tv_usec = 0 };
}

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelBootTime;
@property (nonatomic, weak) IBOutlet UILabel *labelBootTimePrecise;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  timeval_t bt = kern_boottime();
  
  NSDate* bootDate = [NSDate dateWithTimeIntervalSince1970:bt.tv_sec + bt.tv_usec / 1.e6];
  self.labelBootTime.text = [NSString stringWithFormat:@"%@", bootDate];
  
  self.labelBootTimePrecise.text = [NSString stringWithFormat:@"Secs: %lld USecs: %lld", (long long)bt.tv_sec, (long long)bt.tv_usec];
}


@end
