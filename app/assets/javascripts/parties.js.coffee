# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.user_list = (department) ->
  $.ajax
    url: '/api/user_list',
    method: 'get',
    dataType: 'json',
    data:
      department: department,
    ,
    success: (res) ->
      options = ''

      for i in res
        options += "<option value=\"#{i.id}\">#{i.name}</option>"

      $('select#party_user').empty()
      $('select#party_user').append options
    ,
