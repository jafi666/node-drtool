###
Reads and converts to human readable array of time periods the data receive from device api.
@param periods [Array] a collection of Period db documents in the format like:
   [{
    "id":2,
    "timePeriods":[
      {"begin":"00:00","end":"00:00","days":31},
      {"begin":"10:30","end":"18:30","days":96}
    ]
  }]
@return [Array] returns a mapped array of periods and timePeriods in representative week days like:
   [{
    "id":2,
    "sunday": {"begin":"00:00","end":"00:00"},
    "monday": {"begin":"00:00","end":"00:00"},
    "tuesday": {"begin":"10:30","end":"18:30"},
    ...
    "saturday": {"begin":"00:00","end":"00:00"}
    ]
  }]
###
readTimePeriods = (periods) ->
  weekMap =
    1: 'monday'
    2: 'tuesday'
    4: 'wednesday'
    8: 'thursday'
    16: 'friday'
    32: 'saturday'
    64: 'sunday'

  result = []

  for period in periods
    periodObject = {}
    periodObject['id'] = period.id
    for timePeriod in period.timePeriods
      days = _getDays(timePeriod.days)
      for day in days
        periodObject[weekMap[day]] =
          begin: timePeriod.begin
          end: timePeriod.end
    result.push periodObject
  result

###
Converts a number into inverted array of bytes and then applies the formula 2^0, 2^1, 2^2...only over bytes
different than 0, and then returns a array of those values.
@param number [Number] the number which will be split and converted to representative week indexes for the weekMap
constant.
@return [Array] and array of representative week indexes like
Example:
  Say Number is 28 the result will be and array [4, 8, 16]
###
_getDays = (number) ->
  result = []
  baseArr = number.toString 2
  invertedArr = baseArr.split('').reverse().join('')
  result.push(Math.pow 2, i) for bin, i in invertedArr when Number(bin) isnt 0
  result
