//
//  DetailViewController.m
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "DetailViewController.h"
#import "ContentService.h"
#import "MOArticleDetail+Dao.h"
#import "ModelUtil.h"

@interface DetailViewController ()
@property(nonatomic, strong) UITextView *detailView;
- (void)configView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(MOArticle *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    
    [self configView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(self.detailView == nil) {
        self.detailView = [[UITextView alloc] initWithFrame:self.view.bounds];
        self.detailView.font = [UIFont systemFontOfSize:16];
        self.detailView.editable = NO;
        self.detailView.showsHorizontalScrollIndicator = NO;

        //Add inset need change the content size also
        //self.detailView.contentInset = UIEdgeInsetsMake(5, 5, 0, 5);
        //self.detailView.contentSize =
        
        [self.view addSubview:self.detailView];
    }
    
    [self configView];
    
}
- (void)configView
{
    if(self.detailItem != nil && self.detailView != nil)
    {
        if(self.detailItem.detail == nil)
        {
            self.detailView.text = @"Loading...";
            
            //load article detail from backend
            [[ContentService instance] getArticleDetail:self.detailItem sucess:^(NSDictionary *data) {
                //insert article detail to db
                MOArticleDetail *detail = [MOArticleDetail insertArticleDetailWithDictionary:data
                                                                       inManagedObjectContext:defaultManagedObjectContext()];
                
                //setup relationships
                self.detailItem.detail = detail;
                detail.article = self.detailItem;
                
                //save the changes
                commitDefaultMOC();
                
                self.detailView.text = self.detailItem.detail.text;
                
            } failure:^{
                //
                self.detailView.text = @"Unable to load the article text.";
            }];
        }
        else
        {
            self.detailView.text = self.detailItem.detail.text;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
