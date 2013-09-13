# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.file_viewer ul.files li a').on 'click', ->
    $('.selected').removeClass 'selected'
    $(this).parent('li').addClass 'selected'
    $('input[type="text"][name="path"]').val $(this).attr('href')

    # List 表示画面へのリンクのパラメータを書き換え
    href = $('a.list').attr('href').split '?'
    old_params = href[1].split '&'
    new_params = ''
    for o in old_params
      new_params += o + '&' unless o.match /^path\=/
    new_params += 'path=' + encodeURIComponent($(this).attr 'href')
    $('a.list').attr 'href',  href[0] + '?' + new_params
    return false
