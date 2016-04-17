assert = require 'assert'

exports.curr_ts = ->
  Date.now()

exports.getRandomItem = (list) ->
  assert.ok list.length
  rand = Math.random()
  list[rand * list.length >> 0]

exports.means = (arr) ->
  (arr.reduce (acc, e) -> acc + e) / arr.length

exports.unorderList =
  rm: (lst, pos) ->
    len = lst.length
    return unless len

    idx = lst.indexOf pos
    return unless !!~idx

    last = lst.pop()
    lst[idx] = last unless idx is len - 1

exports.orderList =
  insert: (lst, item) ->
    pos = @nearly lst, item
    if pos is 0
      lst.unshift item
    else if pos is lst.length
      lst.push item
    else
      lst.splice pos, 0, item

  nearly: (lst, p, start, end) ->
    start ?= 0
    end ?= lst.length and lst.length - 1

    idx = lst.indexOf p, start
    if ~idx and idx <= end
      idx
    else
      binarySearch lst, p, start, end

  deflate: (lst, {from = 0, mutable, movedCallback, done} = {}) ->
    to = lst.length - 1
    padding = unless mutable
      lst = lst[from..]
      _from = from
      [to, from] = [to - from, 0]
      _from
    else
      0

    step = 0
    for idx in [from..to]
      elem = lst[idx]
      if elem?
        new_idx = idx - step
        if step
          lst[new_idx] = elem
          delete lst[idx]
          movedCallback? elem, new_idx + padding, idx + padding
      else
        step++
        
    truncate_idx = lst.length - step
    lst = lst[...truncate_idx]
    done? lst, step
    lst

binarySearch = (lst, p, start, end) ->
  return 0 if lst.length is 0
  idx = (start + end) // 2
  mid = lst[idx]

  if p > mid
    if start is end
      idx + 1
    else
      binarySearch lst, p, idx + 1, end
  else if p < mid
    if start is idx
      idx
    else
      binarySearch lst, p, start, idx - 1
  else
    idx
