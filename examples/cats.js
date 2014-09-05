Sonrai = require('./sonrai-bundle')

MyDatabase = new Sonrai.Databases.InMemory()

CatModel = Sonrai.Model.new({
    name: Sonrai.Fields.StringField(),
    gender: Sonrai.Fields.StringField(),
    birthday: Sonrai.Fields.DateTimeField({
      default: function() {
        return new Date()
      }
    })
  })

Cat = MyDatabase.register(CatModel)

obj = new Cat({
    name: "George",
    gender: "male"
  })

obj.save(function() {
    q = Cat.query().filter({ name: "George" })
    q.end(function(results) {
      console.log(results[0].get('name'))
    })
  })
