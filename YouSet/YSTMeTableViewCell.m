//
//  YSTMeTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/13/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTMeTableViewCell.h"

@interface YSTMeTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation YSTMeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
   // _description.textAlignment = NSTextAlignmentJustified;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithTodo:(YSTToDo *)todo andUserRepresentation:(YSTUser*)userRep{
    self.desciption.text = todo.todo;
    _userRepresentation = userRep;
    _todo = todo;
    
    if (_userRepresentation.ID == [YSTUser sharedUser].ID) {
        // usuario esta olhando seus proprios todos
        if (todo.idCreatedBy == userRep.ID) {
            // todo creado pelo usuario, verificar se ele criou o todo para alguem, se nao, esconder rodape
            
            NSString *s = @"";
            BOOL todoToAnotherUser = NO;
            for (YSTAssignee *a in todo.assignee) {
                if (a.idUser != userRep.ID) {
                    s = [s stringByAppendingFormat:@"%@. ",a.nameOfUser];
                    todoToAnotherUser = YES;
                }
            }
            
            if (todoToAnotherUser) {
                // todo feito para outro usuario
                _usersOfTask.hidden = NO;
                _usersOfTask.text = [NSLocalizedString(@"Para ", nil) stringByAppendingString:s];
                
            } else {
                // esconder label
                _usersOfTask.hidden = YES;
            }
            
        } else {
            // todo nao foi criado pelo usuario, veio de outra pessoa
            _usersOfTask.hidden = NO;
            _usersOfTask.text = [NSString stringWithFormat:NSLocalizedString(@"De %@", nil),todo.createdByName];
        }
        
        
      
    } else {
        // usuario esta olhando todos de seus amigos
        
        // todos criados pelo usuario que estamos olhando, nao mostrar
        if (userRep.ID == todo.idCreatedBy) {
            // verificar se os todos foram criados para outro usuario
            
            NSString *s = @"";
            BOOL todoToAnotherUser = NO;
            for (YSTAssignee *a in todo.assignee) {
                if (a.idUser != userRep.ID) {
                    s = [s stringByAppendingFormat:@"%@. ",a.nameOfUser];
                    todoToAnotherUser = YES;
                }
            }
            
            if (todoToAnotherUser) {
                // todo feito para outro usuario
                _usersOfTask.hidden = NO;
                _usersOfTask.text = [NSLocalizedString(@"Para ", nil) stringByAppendingString:s];
                
            } else {
                // esconder label
                _usersOfTask.hidden = YES;
            }
            
        } else {
            // mostrar quando for criado por outros usuarios, e quando o usuario cria pelo o usuario
            _usersOfTask.hidden = NO;
            _usersOfTask.text = [NSString stringWithFormat:NSLocalizedString(@"De %@", nil),todo.createdByName];
        }
    }
    
}

@end
