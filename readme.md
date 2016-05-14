# Castbot

Castbot is an audio experiment by [David MacDonald](http://davidmacdonaldmusic.com) to generate an autonomous podcast.

The feed is currently at <http://effing.work/castbot/castbot-feed.xml>

## Dependencies

- ChucK to generate audio
- libav to convert to MP3
- [ruby-mp3info](https://github.com/moumar/ruby-mp3info) Ruby gem (`sudo gem install ruby-mp3info`)

## Changelog

- 2016-05-14 v0.2
    - Flexible tempo
    - Multiple shakers in polyrhythmic relationships
    - Removed jingly shakers
    - New metadata in feed
- 2016-05-10 v0.1.1
    - changed ffmpeg to libav (My Raspberry Pi seemed to be allergic to ffmpeg.)
- 2016-05-09 v0.1
    - proof-of-concept
    - runs manually
