//
//  YSTEditableTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/22/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTEditableTableViewCell.h"

@implementation YSTEditableTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (NSString *) sendContentTF {
    NSString *content;
    
    content = self.contentTF.text;
    
    return content;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _auxTodo.todo = textField.text;
    return YES;
}

- (void)selectionDidChange:(id<UITextInput>)textInput {

}

- (void)selectionWillChange:(id<UITextInput>)textInput {
    
}

- (void)textWillChange:(id<UITextInput>)textInput {
    
}

- (void)textDidChange:(id<UITextInput>)textInput {
    
}

@end
