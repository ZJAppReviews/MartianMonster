# Martian Monster
### The Story
Disney's 50-year old classic "Thrilling, Chilling Sounds of the Haunted House" was ressurected when the band Phish produced an entirely original set of music to accompany it on Halloween 2014. 

The final act of the performance, "Martian Monster", makes use of these spooky soundbites, which have now become a mainstay in Phish's live performances.

Here is an iOS app that allows the user to have some fun with those very same soundbites, including the ability to manipulate the pitch (just as the band does on stage).

![demo](Demo/martian_monster_phish_app_gif.gif)

I originally built this app to turn my iPhone into an improvised effect pedal from which I could trigger the soundbites with my feet while playing guitar. I decided to add more features and share this in the Apple App store for free.

You can listen to "Martian Monster" here: https://www.youtube.com/watch?v=bA7hJEYhzDY

### Usage
The audio is managed via an AVAudioEngine in conjunction with AVAudioPlayerNodes and AVAudioPCMBuffer objects. 

Facebook's [FBShimmeringView](https://github.com/facebook/Shimmer) is also harnessed as a subview within the drop-down banner / UIButton.
