// ignore_for_file: constant_identifier_names

import 'package:movie/config/application.dart';
import 'package:movie/const/api_path.dart';
import 'package:movie/shared/models/profile_model.dart';

/// Enums

enum RestAPIRequestMethods { get, put, post, delete, patch }

enum InputFieldError { empty, invalid, notmatch }

enum LibraryType { Main, Drafts }

enum PostType { CreatePost, CreateLibraryPost, UpdatePost, UpdateLibraryPost }

enum ShareType { Reel, Group, Story, Feed }

enum ColorType { TextColor, ButtonColor, TextImageColor }

/// Media Type
enum MediaType { Image, Video, Gif, Pdf }

enum BlogPost {
  Wix,
  Weebly,
  Squarespace,
}

enum JournalPostType { Draft, Scheduled, Published }

enum SocialMedia {
  Instagram,
  Facebook,
  Snapchat,
  Twitter,
  Tiktok,
  AlexaDevice,
  LinkedIn,
  GoogleMB,
  WhatsApp,
}

const itemsPerPage = 100;

abstract class AppSecureStoragePreferencesKeys {
  static const String _email = "USERNAME";
  static const String _authToken = "AUTH_TOKEN";
  static const String _password = "USER_PASSWORD";
  static const String _refreshToken = "REFRESH_TOKEN";
  static const String _fcmToken = "FCM_TOKEN";
  static const String _accessToken = "ACCESS_TOKEN";

  static String get email => _email;
  static String get authToken => _authToken;
  static String get userPassword => _password;
  static String get refreshToken => _refreshToken;
  static String get fcmToken => _fcmToken;
  static String get accessToken => _accessToken;
}

abstract class AppLocalStoragePreferencesKeys {
  static const String _loggedIn = "LOGGEDIN";
  static const String _calendarId = "CALENDERID";
  static const String _calenderName = "CALENDERNAME";
  static const String _categoryId = 'CATEGORYID';
  static const String _categoryName = 'CATEGORYNAME';
  static const String _folderId = "FOLDERID";
  static const String _folderName = "FOLDERNAME";

  static String get loggedIn => _loggedIn;
  static String get calendarId => _calendarId;
  static String get calenderName => _calenderName;
  static String get categoryId => _categoryId;
  static String get categoryName => _categoryName;
  static String get folderId => _folderId;
  static String get folderName => _folderName;
}

abstract class AppTimezonePreferencesKeys {
  static const String _timezone = "TIMEZONE";

  static String get email => _timezone;
}

/// Social Media Image Path
const String facebookImage = "assets/images/facebook_logo.png";
const String instagramImage = "assets/images/ic_instagram_logo.png";
const String pintrestImage = "assets/images/ic_pinterest_logo.png";
const String alexaImage = "assets/images/ic_alexa_small.png";
const String snapchatImage = "assets/images/snap_chat.jpeg";
const String tiktokImage = "assets/images/tiktok.jpeg";
const String googleMyBusiness = "assets/images/google_bussiness.svg";
const String linkedImage = "assets/images/linked_image.svg";
const String twitterImage = "assets/images/twitter_image.svg";
const String mediumImage = "assets/images/medium.png";
const String hootsuiteImage = "assets/images/medium.png";
const String wordpressImage = "assets/images/wordpress.png";
const String libraryImage = "assets/images/library.jpeg";
const String hootSuiteImage = "assets/images/hoot-suite.svg";
const String woofyImage = "assets/images/logo_outlines.png";
const String whatsAppImage = "assets/images/whatsapp.png";
const String alexaFireTVApp = "assets/images/fireTVApp.png";
const String mailchimp = "assets/images/Mailchimp.jpg";
const String weeblyImage = "assets/images/weebly.svg";
const String wixImage = "assets/images/wix.svg";
const String squareSpaceImage = "assets/images/square_space.png";
const String shopifyImage = "assets/images/shopify.svg";

/// Create Post action type
const List<Map<String, String>> actionType = [
  {
    "title": "Learn More",
    "value": "LEARN_MORE",
  },
  {
    "title": "Book",
    "value": "BOOK",
  },
  {
    "title": "Order",
    "value": "ORDER",
  },
  {
    "title": "Shop",
    "value": "SHOP",
  },
  {
    "title": "Sign Up",
    "value": "SIGN_UP",
  },
  {
    "title": "Call Us",
    "value": "CALL",
  }
];

const List<String> fontsList = [
  'auto',
  'Glyphicons Halflings',
  'cursive',
  'emoji',
  'fangsong',
  'fantasy',
  'inherit',
  'initial',
  'math',
  'monospace',
  'none',
  'revert',
  'sans-serif',
  'serif',
  'system-ui',
  'ui-monospace',
  'ui-rounded',
  'ui-sans-serif',
  'ui-serif',
  'unset',
  '-webkit-body',
];

const String PEG = "peg";
const String JPG = "jpg";
const String GIF = "gif";
const String PNG = "png";
const String MP4 = "mp4";
const String MKV = "mkv";

const List<String> hashtags = ["Trending Hashtags", "My First Hashtags"];

const String alreadyPostedError =
    "Oops, looks like you already scheduled something before (in the last or next 30 days) or have a post in your library that’s 100% similar to this post.";

const socialMediaReminders = {
  "instagram": [
    'storyReminder',
    'feedReminder',
    'reelReminder',
    'carouselReminder'
  ],
  "instagram_business": [
    'feedReminderIGB',
    'carouselReminderIGB',
    'reelReminderIGB',
  ],
  "facebook": [
    'storyReminder',
    'personalTimelineReminder',
    'nonAdminGroupsReminder'
  ],
  "tikTok": ['storyReminder', 'feedReminder'],
};

const smReminderTexts = {
  "feedReminder": 'Feed Reminder to Mobile App',
  "reelReminder": 'Reel Reminder to Mobile App',
  "carouselReminder": 'Carousel Reminder to Mobile App',
  "storyReminder": 'Story Reminder to Mobile App',
  "personalTimelineReminder": 'Feed (Personal Timeline) Reminder to Mobile App',
  "nonAdminGroupsReminder": 'Non-Admin Groups Reminder to Mobile App',
  'autoFeed': "Auto posting to Feed",
  'autoReel': "Auto posting to Reel",
  'autoCarousel': "Auto posting to Carousel",
};

const subscriptionType = {
  'monthly_pro': 'monthly_pro',
  'annual_pro': 'annual_pro',
  'monthly_smb': 'monthly_smb',
  'annual_smb': 'annual_smb',
  'monthly_agency': 'monthly_agency',
  'annual_agency': 'annual_agency',
  'monthly_single': 'monthly_single',
  'annual_single': 'annual_single',
  'monthly_agencyplus': 'monthly_agencyplus',
  'annual_agencyplus': 'annual_agencyplus',
  'monthly_enterprise': 'monthly_enterprise',
  'annual_enterprise': 'annual_enterprise',
  'premium': 'premium',
};

List<String> agencyPlan = [
  subscriptionType['annual_agency']!,
  subscriptionType['monthly_agency']!
];
List<String> smbPlan = [
  subscriptionType['monthly_smb']!,
  subscriptionType['annual_smb']!,
];
List<String> proPlan = [
  subscriptionType['monthly_pro']!,
  subscriptionType['annual_pro']!
];
List<String> singlePlan = [
  subscriptionType['monthly_single']!,
  subscriptionType['annual_single']!
];
List<String> agencyPlusPlan = [
  subscriptionType['monthly_agencyplus']!,
  subscriptionType['annual_agencyplus']!
];
List<String> enterprisePlan = [
  subscriptionType['monthly_enterprise']!,
  subscriptionType['annual_enterprise']!
];

const List<Map<String, String>> entertainmentAccounts = [
  {
    "image_path": alexaImage,
    "account_name": "Add Alexa account",
    "account_add_url": "",
  },
];

const String apiKey = "8b4165dd";
