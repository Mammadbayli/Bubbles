//
//  Constants.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/29/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
NSString *const SERVER_HOST_NAME = @"ejabberd.bubbles.mammadbayli.com";
NSString *const VIRTUAL_HOST_NAME = @"im.bubbles.mammadbayli.com";

#if DEBUG
NSString *const API_URL = @"http://localhost";
#else
NSString *const API_URL = @"https://api.bubbles.mammadbayli.com";
#endif

NSString *const ACCOUNT_TABLE_DID_SELECT_ROW = @"account-table-did-select-row";

NSString *const MESSAGE_STATUS_NONE = @"none";
NSString *const MESSAGE_STATUS_PENDING = @"pending";
NSString *const MESSAGE_STATUS_SENT = @"sent";
NSString *const MESSAGE_STATUS_DELIVERED = @"delivered";
NSString *const MESSAGE_STATUS_FAILED = @"failed";
NSString *const MESSAGE_STATUS_READ = @"read";

NSString *const MESSAGE_TYPE_TEXT = @"text";
NSString *const MESSAGE_TYPE_PHOTO = @"photo";
NSString *const MESSAGE_TYPE_AUDIO = @"audio";
NSString *const MESSAGE_TYPE_FORWARDED_POST = @"post";

NSString *const MESSAGE_DATA = @"data";
NSString *const MESSAGE_PARENT = @"parent";
NSString *const MESSAGE_FILE = @"file";
NSString *const MESSAGE_FILES = @"files";
NSString *const MESSAGE_FILE_ATTRIBUTE_NAME = @"name";
NSString *const MESSAGE_FILE_ATTRIBUTE_TYPE = @"type";

NSString *const MESSAGE_ATTRIBUTE_TIMESTAMP = @"timestamp";
NSString *const MESSAGE_ATTRIBUTE_TYPE = @"type";
NSString *const MESSAGE_ATTRIBUTE_IS_FORWARDED = @"isForwarded";
NSString *const MESSAGE_ATTRIBUTE_PARENT_ID = @"parent_id";

NSString *const LOCAL_FILES_PHOTO_FOLDER = @"photo";
NSString *const LOCAL_FILES_AUDIO_FOLDER = @"audio";

NSString *const FRIEND_REQUEST_ACTION_NOTIFICATION = @"request-action";
NSString *const USER_OFFLINE_NOTIFICATION = @"user-offline";
NSString *const USER_ONLINE_NOTIFICATION = @"user-online";
NSString *const USER_COMPOSING_NOTIFICATION = @"user-composing";
NSString *const USER_PAUSED_COMPOSING_NOTIFICATION = @"user-paused-composing";
NSString *const LANGUAGE_DID_CHANGE_NOTIFICATION = @"language-did-change";
NSString *const MESSAGE_LONG_PRESS_NOTIFICATION = @"message-long-press-action";
//NSString *const DID_AUTHENTICATE_NOTIFICATION = @"did-authenticate";
NSString *const DID_NOT_AUTHENTICATE_NOTIFICATION = @"did-not-authenticate";

NSString *const XMPP_STREAM_START_CONNECTING_NOTIFICATION = @"xmpp.stream.startConnecting";
NSString *const XMPP_STREAM_DID_CONNECT_NOTIFICATION = @"xmpp.stream.didConnect";
NSString *const XMPP_STREAM_DID_NOT_CONNECT_NOTIFICATION = @"xmpp.stream.didNotConnect";
NSString *const XMPP_STREAM_DID_DISCONNECT_NOTIFICATION = @"xmpp.stream.didDisconnect";

NSString *const XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION = @"xmpp.stream.didAuthenticate";
NSString *const XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION = @"xmpp.stream.didNotAuthenticate";

NSString *const XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_ERROR = @"xmpp.lastActivity.error";
NSString *const XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_RESULT = @"xmpp.lastActivity.result";

NSString *const USER_FULL_NAME_KEY = @"user_full_name";
NSString *const USER_PHOTOS_KEY = @"profile-pictures";
NSString *const USER_NAME_KEY = @"name";
NSString *const USER_SURNAME_KEY = @"surname";
NSString *const USER_PHONE_NUMBER_KEY = @"phone-number";
NSString *const USER_EDUCATION_KEY = @"education";
NSString *const USER_INTERESTS_KEY = @"interests";
NSString *const USER_ABOUT_KEY = @"about";
NSString *const USER_CAREER_KEY = @"career";

//NSString *const PASSWORD_REGEX = @"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])([a-zA-Z0-9@$!%*?&]{6,16})$";
NSString *const PASSWORD_REGEX = @"^(([0-9])|([a-z])|([A-Z])|([@$!%*?#&])){6,16}$";
NSString *const USERNAME_REGEX = @"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$";

NSString *const PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE = @"MESSAGE.NEW_MESSAGE";
NSString *const PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE = @"MESSAGE.NEW_GROUP_MESSAGE";
NSString *const PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE = @"ADMIN.USERNAME_CHANGE";
NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_NEW_FRIEND_REQUEST = @"ROSTER.NEW_FRIEND_REQUEST";
NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_ACCEPT_FRIEND_REQUEST = @"ROSTER.ACCEPT_FRIEND_REQUEST";
NSString *const PUSH_NOTIFICATION_ACTION_ROSTER_DECLINE_FRIEND_REQUEST = @"ROSTER.DECLINE_FRIEND_REQUEST";

NSString *const AVCONTROLLER_PLAYBACK_DID_START = @"avcontroller.playback.start";
NSString *const AVCONTROLLER_PLAYBACK_DID_RESUME = @"avcontroller.playback.resume";
NSString *const AVCONTROLLER_PLAYBACK_DID_STOP = @"avcontroller.playback.stop";
NSString *const AVCONTROLLER_PLAYBACK_DID_PAUSE = @"avcontroller.playback.pause";
NSString *const AVCONTROLLER_PLAYBACK_DID_FINISH = @"avcontroller.playback.finish";
NSString *const AVCONTROLLER_PLAYBACK_CURRENT_TIME_DID_CHANGE = @"avcontroller.playback.current-time";

NSString *const NAVIGATE_TO_CHAT = @"navigate.to.chat";
NSString *const NAVIGATE_TO_ROSTER = @"navigate.to.roster";
NSString *const NAVIGATE_TO_POST = @"navigate.to.post";
