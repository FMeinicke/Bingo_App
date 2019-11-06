# Bingo App
A simple bingo app written in C++ and QML

This app was developed for a CS project while I was studying. 
It fulfilled all of the requirements at the time meaning you can play bingo with as much scorecards as you like and even create custom scorecards (see below for a list of all features). 
But in my opinion the app is definitely not complete.

However, I learned a lot of new stuff about QML and how to interact from C++ with QML and vice versa while developing the app. 
Feel free to browse and play around with the source code. 

## Features
### Basic
* Play bingo with as many random scorecards as you like (actually the maximum is 20 cards - but who plays with so many cards anyway...)
* Enter the number that was called out and it gets marked automatically on all of your scorecards
* If you get a bingo, the view will show the corresponding card and the fields that make up the bingo
* Restart a game by removing all of the markers from all scorecards
* Start a new game by giving all new cards
* Choose, whether you would like to play with diagonal bingos
### Custom
* Create as many custom scorecards before playing
* "Scan" a scorecard (basically you can just take a picture, but I wanted to play a bit with QML's `Camera` type.
Therefore most of this code is taken from Qt's [declarative-camera example](https://code.qt.io/cgit/qt/qtmultimedia.git/tree/examples/multimedia/declarative-camera).
I just modified some stuff and took out the things I didn't need.)

## Things about QML I learned during development
I didn't know right from the start how certain things are done in QML or how I would interact from QML with my C++ classes.
So, for future references, I'm going to list the most important things I learned while working on that project in the following

### States are awesome
They save you from copying and pasting a QML component and just changing a few things (like, for example, I want my form `x` to be readonly in this view but editable in that view).
Additionally they are great for creating amazing animations.

### Using C++ models in QML views
> #### TL;DR
> Better use a `QAbstractItemModel` subclass approach even for what you might think is 'simple' data. 
> It's much more extensible than other approaches.
> Plus, you can create as many model instances as you need directly from QML.

<details>

I knew that I wanted to seperate my data from its visualization. 
I also know Qt's MVC system from the C++ side.
So, I searched around and found [this](https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html) really good explanation of all of the different methods you can integrate your C++ data models with QML views.

Since I thought the data I have to keep is quite simple (just a number and one or two `bool`s for each field) I started with a QObjectList-based model. 
For better useability I created a class (derived from `QObject`, of course) to represent a number field on a bingo scorecard as it was done in the docs, as well.
This went well until I wanted my model to have some overall attributes that would apply to all number fields.
At that point, I definitely had to switch to the `QAbstractItemModel` subclass approach where I derived my custom model class from `QAbstractListModel`.

This turned out to be the best approach for this problem.
 It also solved problems I would have ran into later when making the cards editable and using multiple scorecards (i.e. multiple models).
With the QObjectList-based approach I would only have one globally shared instance of my model since it is just set as a QML context property.
The `QAbstractItemModel` subclass approach, however, allows you to make the whole type available to QML (using [`qmlRegisterType`](https://doc.qt.io/qt-5/qtqml-cppintegration-definetypes.html#registering-c-types-with-the-qml-type-system)).
</details>

### Creating `n` dynamic QML objects 
> #### TL;DR
> Instead of a `for` loop inside the `Component.onCompleted` signal handler use a `Repeater`.

<details>

My initial thoughts on how I might create 5 scorecards, for example, were to use the `Component.onCompleted` signal handler of the corresponding parent object. 
There I would use a simple `for` loop to create the cards. 
The QML [documentation](https://doc.qt.io/qt-5/qtqml-javascript-dynamicobjectcreation.html) on this was really helpful and I had what I wanted pretty fast:
```qml
Component.onCompleted: {
  for (var i = 0; i < numScoreCards; i++) {
    let component = Qt.createComponent("BingoCardForm.qml")
    if (component.status == Component.Ready) {
      let bingoCard
      if (customModels) {
        bingoCard = component.createObject(scoreCardsView, {
                                             "scoreCardModel": customModels[i]
                                           })
      } else {
        bingoCard = component.createObject(scoreCardsView)
      }

      bingoCards.push(bingoCard)
    }
  }
}
```
Later, I stumbled across the `Repeater` QML object which essentially does the exact same thing while being better readable and less code. 
The `Repeater` allows you to create any number of similar items. 
It uses a model and a delegate. 
For each item in the model a delegate is instantiated. 
The best thing is that plain numbers are already valid models in QML. 
This means that my kind of ugly `for` loop could be replaced by this concise declaration:
```qml
Repeater {
  model: numScoreCards

  BingoCardForm {
    // scoreCardModel will be undefined if there is no custom model
    // -> BingoCardForm will create a new model with random fields
    scoreCardModel: customModels[index]
  }
}
```
</details>

### Use layouts whereever possible
> #### TL;DR
> Use layouts instead of manually `anchor`ing items to one another for relative positing.

<details>

I know, it seems really obvious, but I didn't use layouts for quite some time.
I tried to use `anchors` for positioning my items relatively to each other.
Though this worked actually quite well, it unfortunatly leads to a lot of boilerplate code.
You can still see this in some files because I was too afraid to touch the code and break something by accident.

Layouts save you from the pain of having to anchor each item to its parent `bottom`, for example.

</details>

### Back button navigation on a `StackView`
> #### TL;DR
> Ensure that the stack view has focus the entire time (`focus: true` and `forceActiveFocus()` are youre friends) and connect to the `Keys.onBackPressed` signal handler.
> To close the app with two back button presses use a `ToolTip` to display a nice *"Press again to quit..."* message and give the user time (~ 2 secs) to press the back button again and exit the app.

<details>

I used a QML `StackView` for this project, since you kind of have this proccess with different steps that eventually lead you to the game page:
1. Select the game mode
    * Classic
    * Blackout [not implemented]
    * Tournament [not implemented]
2. Configure your scorecards
    * Use random numbers for the cards
    * Enter your custom numbers
    * Scan a scorecard and use its numbers [not implemented]
3. Finally, play the game

So, as you can see, these are quite a lot of pages.
By default a `StackView` comes along with a `Drawer` displaying all of the pages.
By swiping from the left edge to the center of the screen you can open the drawer and select the page you want to go to.

However, I wanted to predefine a path through the app for the user.
It doesn't make sense to start the game before you configured your scorecards, right?
So, the first step was to kick out the `Drawer` and only provide specific buttons to go forward to the next page by pushing them onto the stack view.
Now there was the question of going back to the previous page. 
The most intuitive thing (at least for most of the Android users) is to press the back button in the navigatino bar.
Unfortunately Qt/QML does not handle back button presses by default let alone pop a page from the stack view without further ado.

So, I had to find a solution myself.
The key here was to ensure the stack view always - and I mean *always* - has focus.
Initially it was enouh to just put `focus: true` inside the declaration of the `StackView` but later I ran into problems with this which is why I ended up doing the following:
```qml
onFocusChanged: {
  if (!focus) {
    forceActiveFocus()
  }
}
```
Now there was just one thing left:
Catch the event when the user presses the back button and just pop a page form the stack.
This can be done quite easily by saying:
```qml
Keys.onBackPressed: {
  pop()
}
```
Great, now the user can navigate really easily and intuitively through my app!

There was just one thing missing for me:
I wanted to have this cool thing where when you are on the main page and press the back button twice within a small time period, the app would close.
Even better would be a little popup saying *"Press again to quit..."* after the first press.

The first thing I needed was a nice popup message.
For this I used a `ToolTip` which is styled just perfectly like I would imagine a popup.
I also tied the tool tips visibility to the `wantsQuit` variable.
```qml
ToolTip {
  id: quitMsg

  text: qsTr("Press again to quit...")
  y: parent.height - 50
  visible: stackView.wantsQuit
  timeout: 2100
  delay: 500
}
```
The `wantsQuit` variable would be set to `true` after I recognised a back button press on the main page.
So, I slightly modified the `Keys.onBackPressed` slot, too.
```qml
Keys.onBackPressed: {
  if (depth > 1) {
    // if not on the main page, don't close the app on back key press
    // just go back one page
    wantsQuit = false
    pop()
  } else if (!wantsQuit) {
    // close on next back button press
    wantsQuit = true
  }
}
```
Lastly, when the user presses the back button for the second time within the 2 seconds period, I want the app to close itself.
Since the tool tip will be visible for the entire 2 seconds (and will have active focus), any key presses will be send to the tool tip. 
Therefore we can detect another back button press by connecting to the `onClosed` signal handler and close the app in there.
```qml
ToolTip {
  id: quitMsg
  //...
  onClosed: {
    if (stackView.wantsQuit) {
      // user pressed back button twice within a small intervall - quit app
      window.close()
    }
  }
}
```

</details>
