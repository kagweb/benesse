# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.file_viewer ul.files li a').on 'click', ->
    $('.selected').removeClass 'selected'
    $(this).parent('li').addClass 'selected'
    $('input[type="hidden"][name="path"]').val $(this).attr('href')
    return false
