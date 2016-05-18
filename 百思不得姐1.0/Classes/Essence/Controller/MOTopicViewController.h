//
//  MOTopicViewController.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/3.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MOTopicViewController : UITableViewController


/**
 *  帖子类型（交给子类去实现）
 */

//不理解，后面就要包装成对象？
@property (nonatomic, assign) MOTopicType  type;


@end
