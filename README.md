Clientside data model system inspired by MongoDB and the Django ORM, with offline storage support.

[![Circle CI](https://circleci.com/gh/krillr/sonrai.png?style=badge)](https://circleci.com/gh/krillr/sonrai)

Design Decisions
======

CoffeeScript
------
Sonrai is written in CoffeeScript, and as such its API is geared towards usage in CoffeeScript. Where possible, helper utilities are provided to make it easier for pure JavaScript usage -- but keep in mind that pure JavaScript is treated as a second-class citizen in Sonrai. 

Promises
------
Sonrai makes gratuitous use of Promises, because let's face it -- callbacks suck. In particular, the lightweight and efficient Q library is used. All async calls will return promises. Please code accordingly!

Query/Object Caching
------
Most frameworks do some sort of object caching. Many do this on the per-query level, caching objects only for that particular query. Sonrai chooses to do things a little differently -- once an object has been loaded, it stays loaded and the same object is always returned every time it turns up in a query. The following code example explains it a bit better.

```CoffeeScript
Cat.query({ name: "George" }).get().then (object) ->
  results[0].set 'name', 'Fred' # Set the name on the object, but don't save it
  console.log results[0].get 'id'
  
Cat.query({ name: "Bob" }).get().then (object) ->
  console.log results[0].get 'id', results[0].get 'name'
```

This behavior might seem a little strange at first, as one is used to dealing with an ORM as if the object were simply an interface to the data in a database. Sonrai attempts to change that paradigm, and treat the objects as first-class citizens. When you query, you'll looking for the objects themselves -- not some data in some far away backend system somewhere. The save method is still required to persist the object changes back to the database backend. At some point in the future, this may change.

CoffeeScript Example
======
```CoffeeScript
# Sonrai makes gratuitous use of the Q promise library, so import it
# so we can make use of it in our app too
Q = require 'q'
Sonrai = require 'sonrai'

# Use an in-memory DB since we don't care about keeping the data past
# this sesion
MyDatabase = new Sonrai.Databases.InMemory()

# Define our model. Note this is not attached to a database yet
class CatModel extends Sonrai.Model
  @fields: {
      name     : Sonrai.Fields.StringField(),
      gender   : Sonrai.Fields.StringField(),
      birthday : Sonrai.Fields.DateTimeField({ default: -> new Date() })
    }

# Register the model with the database. This returns a new class tied
# to the database it is registered with. This allows the same model
# to be used with multiple database backends, without any nasty
# sub-classing
Cat = MyDatabase.register CatModel

#Define a bunch of cats
fixtures = [
  {
    name: "George",
    gender: "male"
  },
  {
    name: "Bill",
    gender: "male"
  },
  {
    name: "Jill",
    gender: "female"
  },
  {
    name: "Emily",
    gender: "female"
  },
]

# Create objects for each fixture
objects = Cat.fromFixtures fixtures

MyDatabase.saveAll objects # Create a Q promise that resolves after each object is saved
  .then Cat.query().count # When all objects are saved, run a count
  .then (count) -> console.log count # When count comes back with data, log it to the console
```

Javascript Example
======
```Javascript
//Sonrai makes gratuitous use of the Q promise library, so import it
// so we can make use of it in our app too
Q = require('q')
Sonrai = require('../sonrai-bundle')

// Use an in-memory DB since we don't care about keeping the data past
// this sesion
MyDatabase = new Sonrai.Databases.InMemory()

// Define our model. Note this is not attached to a database yet
CatModel = Sonrai.Model.new(
  {
      name     : Sonrai.Fields.StringField(),
      gender   : Sonrai.Fields.StringField(),
      birthday : Sonrai.Fields.DateTimeField({ default: function() { new Date() } })
    }
  )

// Register the model with the database. This returns a new class tied
// to the database it is registered with. This allows the same model
// to be used with multiple database backends, without any nasty
// sub-classing
Cat = MyDatabase.register(CatModel)

//Define a bunch of cats
fixtures = [
  {
    name: "George",
    gender: "male"
  },
  {
    name: "Bill",
    gender: "male"
  },
  {
    name: "Jill",
    gender: "female"
  },
  {
    name: "Emily",
    gender: "female"
  },
]

// Create objects for each fixture
objects = Cat.fromFixtures(fixtures)

MyDatabase.saveAll(objects) // Create a Q promise that resolves after each object is saved
  .then(Cat.query().count) // When all objects are saved, run a count
  .then(function(count) { console.log(count) }) // When count comes back with data, log it to the console
```
