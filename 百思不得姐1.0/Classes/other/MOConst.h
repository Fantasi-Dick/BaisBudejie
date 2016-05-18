//
//  MOConst.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/1.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const MOTitilesViewH;
UIKIT_EXTERN CGFloat const MOTitilesViewY;
UIKIT_EXTERN CGFloat const MOTopicCellMargin;
UIKIT_EXTERN CGFloat const MOTopicCellTextY;
UIKIT_EXTERN CGFloat const MOTopicCellBottomBarH;

typedef enum{
    MOTopicTypeAll = 1,
    MOTopicTypePicture = 10,
    MOTopicTypeWord = 29,
    MOTopicTypeVoice = 31,
    MOTopicTypeVideo = 41,
    
}MOTopicType;


/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const MOTopicCellPictureMaxH;

/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN CGFloat const MOTopicCellPictureBreakH;

/** MOUserModel模型 - 性别属性值 */
UIKIT_EXTERN NSString const *MOUserSexMale;
UIKIT_EXTERN NSString const *MOUserSexFemale;

/*精华--cell- 最热评论标题的高度*/
UIKIT_EXTERN CGFloat MOTopicCellTopCmtTitleH ;
