//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Rose on 6/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
  CCPhysicsNode *_physicsNode;
  CCNode *_contentNode;
  CCNode *_levelNode;
  CCNode *_catapultArm;
  CCNode *_pullbackNode;
  CCNode *_mouseJointNode;
  CCPhysicsJoint *_mouseJoint;
  CCNode *_currentPenguin;
  CCPhysicsJoint *_penguinCatapultJoint;
}

- (void)didLoadFromCCB {
  
  self.userInteractionEnabled = TRUE;
  CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
  [_levelNode addChild:level];
  
  // nothing shall collide with our invisible nodes
  _pullbackNode.physicsBody.collisionMask = @[];
  _mouseJointNode.physicsBody.collisionMask = @[];
  
  // visualize physics bodies & joints
  _physicsNode.debugDraw = TRUE;
}

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint touchLocation = [touch locationInNode:_contentNode];
  
  // start catapult dragging when a touch inside of the catapult arm occurs
  if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation))
  {
    // move the mouseJointNode to the touch position
    _mouseJointNode.position = touchLocation;
    
    // setup a spring joint between the mouseJointNode and the catapultArm
    _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:150.f];
  }
}


- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint touchLocation = [touch locationInNode:_contentNode];
  _mouseJointNode.position = touchLocation;
}

- (void)releaseCatapult {
  if (_mouseJoint != nil)
  {
    // releases the joint and lets the catapult snap back
    [_mouseJoint invalidate];
    _mouseJoint = nil;
    
  }

}
-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  [self releaseCatapult];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
  [self releaseCatapult];
}

- (void)launchPenguin {
  self.position = ccp(0, 0);
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
  [_contentNode runAction:follow];

}

- (void)retry {
  // reload this level
  [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}


@end
