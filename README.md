# movietrackr
---

Movietrackr is an app for saving, rating and writing reviewing for your favorite movies using TheMovieDB API and Firebase.

## Screenshots
---
<p align="center">
  <img src="/images/home_page.jpg" alt="Home Page" width="48%">
  <img src="/images/seach_page.jpg" alt="Search Page" width="48%">
  <br><br>
  <img src="/images/movie_details_page.jpg" alt="Movie Details 1" width="48%">
  <img src="/images/movie_details_page_2.jpg" alt="Movie Details 2" width="48%">
  <br><br>
  <img src="/images/movie_details_page_3.jpg" alt="Movie Details 3" width="48%">
  <img src="/images/profile_page.jpg" alt="Profile Page" width="48%">
  <br><br>
  <img src="/images/profile_page_watch_later.jpg" alt="Watch Later" width="48%">
</p>

## Features
---

- Authentication with Firebase
- Posting reviews on movies
- Adding movies to Watch Later
- Looking up movies
- Movie Details page
- Profile page
- Settings page
- Custom widgets
- Updating account (Username, Bio)
- Opening other apps from links (YouTube, Browsers)

## Packages
---

| Package                                                                   | Usage                                  |
|---------------------------------------------------------------------------|----------------------------------------|
| [http](https://pub.dev/packages/http)                                     | Making HTTP requests                   |
| [firebase_core](https://pub.dev/packages/firebase_core)                   | To use the Firebase Core API           |
| [firebase_auth](https://pub.dev/packages/firebase_auth)                   | To use the Firebase Auth API           |
| [firebase_database](https://pub.dev/packages/firebase_database)           | To use the Firebase Databse API        |
| [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)                 | Adding and using .env files            |
| [google_fonts](https://pub.dev/packages/google_fonts)                     | Using fonts from fonts.google.com      |
| [photo_view](https://pub.dev/documentation/flutter_photo_view/latest/)    | Opening and zooming in on pictures     |
| [google_nav_bar](https://pub.dev/packages/google_nav_bar)                 | Navbar for main_screen                 |
| [country_flags](https://pub.dev/packages/country_flags)                   | Using country flag icon                |
| [url_launcher](https://pub.dev/packages/url_launcher)                     | Opening other apps from links          |
| [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)     | Icon package                           |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | Updating the app's icon                |
| [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)   | Native splash for when opening the app |

## Design Patterns
---
- Singleton - objects that communicate with TheMovieDB API and 
- MVC - folder structure and separation of roles

## License
---
This project is licensed under the terms of the [MIT license](LICENSE).

## Installing and running
---
1. Clone the repository
2. Register an account on [TheMovieDB](https://www.themoviedb.org) and create your API Key.
3. Create a .env file in the root directory and add the your API Key:

```
API_KEY=-YOUR API_KEY-
```

4. Create a Firebase project and add an Android and IOS app.
5. Go to Authentication, then to Sign-in Method and add Email/Password
6. Go to Realtime Database and add the following rules:

```
{
  "rules": {
    "reviews": {
      ".read": true,
      "$movieId": {
        ".indexOn": ["timestamp"],
        "$userId": {
          ".write": "auth != null && auth.uid == $userId",
          ".validate": "newData.hasChildren(['content', 'rating', 'username', 'timestamp'])"
        }
      }
    },
    "users": {
      "$userId": {
        ".read": "auth != null && auth.uid == $userId",
        ".write": "auth != null && auth.uid == $userId",
          "bio": {
          ".validate": "newData.isString() && newData.val().length <= 150"
        }
      }
    }
  }
}
```