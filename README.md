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
* If you get a bingo, the view will show the corresponding card and the fields that make uo the bingo
* Restart a game by removing all of the markers from all scorecards
* Start a new game by giving all new cards
* Choose, whether you would like to play with diagonal bingos
### Custom
* Create as many custom scorecards before playing

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

### Creating `n` dynamic QML objects 
> #### TL;DR
> Use a `Repeater` instead of a `for` loop inside the `Component.onCompleted` signal handler.

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
Later I stumbled across the `Repeater` QML object which essentially does the exact same thing while being less and better readable code. 
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
