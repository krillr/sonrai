Clientside data model system inspired by MongoDB and the Django ORM, with offline storage support.

[![Circle CI](https://circleci.com/gh/krillr/sonrai.png?style=badge)](https://circleci.com/gh/krillr/sonrai)

CoffeeScript Example
======
```CoffeeScript
# Sonrai makes gratuitous use of the Q promise library, so import it
# so we can make use of it in our app too
Q = require 'q'
Sonrai = require '../src/sonrai-bundle'

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
objects = (new Cat data for data in fixtures)

# Create a Q promise that resolves after each object is saved
save = Q.all((object.save() for object in objects))

# When all objects are saved, run a count
count = save.then(Cat.query().count)

# When count comes back with data, log it to the console
count.then (count) -> console.log count
```

