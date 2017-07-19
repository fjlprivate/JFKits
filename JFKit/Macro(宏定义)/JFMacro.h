//
//  JFMacro.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#ifndef JFMacro_h
#define JFMacro_h


// ******** [尺寸相关] ********

#define JFSCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define JFSCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define JFSCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height





// 判断是否退出的block
typedef BOOL (^ isCanceledBlock) (void);


#endif /* JFMacro_h */
