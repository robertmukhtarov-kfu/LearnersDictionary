# Learner's Dictionary
An iOS 11+ app for English learners who wish to expand their vocabulary.

The app was built as **a practice project** in order to learn how to create native iOS apps using the MVP with Coordinators architecture, and it isn't actively maintained.

The UI is divided into 3 sections described below.

## Search
In this tab you can search for word definitions. Each dictionary entry contains separate definitions for different parts of speech, pronunciation (phonetic transcription + audio), and some additional information, such as countability, style, transitivity, etc. The data is retrieved from [Merriam-Webster's Learner's Dictionary with Audio API](https://dictionaryapi.com/products/api-learners-dictionary).

https://github.com/robertmukhtarov-kfu/LearnersDictionary/assets/68117935/d1847148-0164-4594-a308-dd86aed9816c

It is also possible to recognize text from a photo: tap on a word you want to look up, and its definition will pop up in a sheet. This feature uses Google's MLKit for OCR.

https://github.com/robertmukhtarov-kfu/LearnersDictionary/assets/68117935/ad7acbfd-8abc-4c34-8e84-05b51c81c6a7

## Discover
This tab shows the word of the day, as well as thematic collections of words. The data comes from Firebase and is curated by the app's developer.

Detail view controllers are presented with a custom `UIViewControllerAnimatedTransitioning` transition that attempts to recreate the App Store card animation:

https://github.com/robertmukhtarov-kfu/LearnersDictionary/assets/68117935/4fa08aee-525c-41e4-9081-861a9ad594e2

## My Collections
User's personal collections of words. If the user is logged in, collections are stored in Firebase Realtime Database and are synced between devices.

https://github.com/robertmukhtarov-kfu/LearnersDictionary/assets/68117935/7881d7cd-bf26-4e47-90d8-fd433102e4eb
