//
//  PDFAlterRecordTabel+CoreDataProperties.h
//  JJPDF
//
//  Created by Mac on 15/12/18.
//  Copyright © 2015年 DJJ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PDFAlterRecordTabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDFAlterRecordTabel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pdfImageFilePath;
@property (nullable, nonatomic, retain) NSNumber *pdfPage;
@property (nullable, nonatomic, retain) NSString *pdfFilePath;

@end

NS_ASSUME_NONNULL_END
