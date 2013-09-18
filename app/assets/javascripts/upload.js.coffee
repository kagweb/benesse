# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.file_action').on 'click', ->
    msg = []
    msg['download'] = false
    msg['upload']   = false
    msg['delete']   = "変更は取り消すことができません。\n削除してもよろしいですか？"
    return confirm msg[$(this).attr('data-alert')] if msg[$(this).attr('data-alert')]
