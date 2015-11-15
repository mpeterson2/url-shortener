# Url Shortener

Shortens long urls into a smaller url like [goo.gl](https://goo.gl) or [bitly.com](https://bitly.com)

On the frontend, you can create shortened urls, then tap the new url in the list to navigate to it or long press to copy the new link.

## Installation

### Backend
 - Install [Node.js](https://nodejs.org)
 - Install [MongoDB](https://www.mongodb.org/)
 - Install [Gulp](http://gulpjs.com/) (npm install -g gulp)
 - Run `npm install` in the `backend` directory

### Frontend
 - Install [CocoaPods](https://cocoapods.org/) (sudo gem install cocoapods)
 - Run `pod install` in `frontend/Url Shortener`

## Running

### Backend
 - Run `gulp` in the `backend` directory

### Frontend
 - Open the `Url Shortener.xcworkspace/` file in `frontend/Url Shortener` with Xcode
 - Run the app

## Tests

### Backend
 - Shut the server down if it is running
 - Be sure `backend/app.js` is runnable (`chmod +x backend/app.js`)
 - Install [Mocha](https://mochajs.org/) (npm install -g mocha)
 - Run `gulp test` in the `backend` directory