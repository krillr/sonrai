Sonrai.Utils = {
  startswith: (s1, s2) ->
    return s1.indexOf(s2) == 0
  intersect: (arr1, arr2) ->
    intersection = []
    for x in arr1
      if x in arr2
        intersection.push(x)
    return intersection

  exclude: (arr1, arr2) ->
    exclusion = []
    for x in arr1
      if x not in arr2
        exclusion.push(x)
    return exclusion

  extend: (obj1, obj2) ->
    for k, v of obj2
      obj1[k] = v

  rand: (x) ->
    return Math.floor(Math.random() * x)

  uuid: ->
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      return v.toString(16)
    )
}

Sonrai.Utils.UUIDRegex = /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i
