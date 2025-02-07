//
//  Constants.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/29/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SERVER_HOST_NAME;
extern NSString *const VIRTUAL_HOST_NAME;
extern NSString *const API_URL;

extern NSString *const MESSAGE_STATUS_NONE;
extern NSString *const MESSAGE_STATUS_PENDING;
extern NSString *const MESSAGE_STATUS_SENT;
extern NSString *const MESSAGE_STATUS_DELIVERED;
extern NSString *const MESSAGE_STATUS_FAILED;
extern NSString *const MESSAGE_STATUS_READ;

extern NSString *const MESSAGE_TYPE_TEXT;
extern NSString *const MESSAGE_TYPE_PHOTO;
extern NSString *const MESSAGE_TYPE_AUDIO;
extern NSString *const MESSAGE_TYPE_FORWARDED_POST;

extern NSString *const MESSAGE_DATA;
extern NSString *const MESSAGE_PARENT;
extern NSString *const MESSAGE_FILE;
extern NSString *const MESSAGE_FILES;
extern NSString *const MESSAGE_FILE_ATTRIBUTE_NAME;
extern NSString *const MESSAGE_FILE_ATTRIBUTE_TYPE;

extern NSString *const MESSAGE_ATTRIBUTE_TIMESTAMP;
extern NSString *const MESSAGE_ATTRIBUTE_TYPE;
extern NSString *const MESSAGE_ATTRIBUTE_IS_FORWARDED;
extern NSString *const MESSAGE_ATTRIBUTE_PARENT_ID;

extern NSString *const LOCAL_FILES_PHOTO_FOLDER;
extern NSString *const LOCAL_FILES_AUDIO_FOLDER;

extern NSString *const USER_OFFLINE_NOTIFICATION;
extern NSString *const USER_ONLINE_NOTIFICATION;
extern NSString *const USER_COMPOSING_NOTIFICATION;
extern NSString *const USER_PAUSED_COMPOSING_NOTIFICATION;
extern NSString *const FRIEND_REQUEST_ACTION_NOTIFICATION;
extern NSString *const MESSAGE_LONG_PRESS_NOTIFICATION;
extern NSString *const ACCOUNT_TABLE_DID_SELECT_ROW;
extern NSString *const LANGUAGE_DID_CHANGE_NOTIFICATION;
//extern NSString *const DID_AUTHENTICATE_NOTIFICATION;
extern NSString *const DID_NOT_AUTHENTICATE_NOTIFICATION;
extern NSString *const XMPP_STREAM_START_CONNECTING_NOTIFICATION;
extern NSString *const XMPP_STREAM_DID_CONNECT_NOTIFICATION;
extern NSString *const XMPP_STREAM_DID_NOT_CONNECT_NOTIFICATION;
extern NSString *const XMPP_STREAM_DID_DISCONNECT_NOTIFICATION;

extern NSString *const XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION;
extern NSString *const XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION;

extern NSString *const XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_ERROR;
extern NSString *const XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_RESULT;

extern NSString *const USER_EDUCATION_KEY;
extern NSString *const USER_INTERESTS_KEY;
extern NSString *const USER_PHOTOS_KEY;
extern NSString *const USER_ABOUT_KEY;
extern NSString *const USER_CAREER_KEY;
extern NSString *const USER_FULL_NAME_KEY;
extern NSString *const USER_NAME_KEY;
extern NSString *const USER_SURNAME_KEY;
extern NSString *const USER_PHONE_NUMBER_KEY;

extern NSString *const PASSWORD_REGEX;
extern NSString *const USERNAME_REGEX;

extern NSString *const PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE;
extern NSString *const PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE;
extern NSString *const PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE;
extern NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_NEW_FRIEND_REQUEST;
extern NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_ACCEPT_FRIEND_REQUEST;
extern NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_DECLINE_FRIEND_REQUEST;

extern NSString *const AVCONTROLLER_PLAYBACK_DID_START;
extern NSString *const AVCONTROLLER_PLAYBACK_DID_RESUME;
extern NSString *const AVCONTROLLER_PLAYBACK_DID_STOP;
extern NSString *const AVCONTROLLER_PLAYBACK_DID_PAUSE;
extern NSString *const AVCONTROLLER_PLAYBACK_DID_FINISH;
extern NSString *const AVCONTROLLER_PLAYBACK_CURRENT_TIME_DID_CHANGE;

extern NSString *const NAVIGATE_TO_CHAT;
extern NSString *const NAVIGATE_TO_ROSTER;
extern NSString *const NAVIGATE_TO_POST;
