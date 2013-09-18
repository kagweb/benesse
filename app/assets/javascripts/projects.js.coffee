# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.file_viewer ul.files li a').on 'click', ->
    $('.selected').removeClass 'selected'
    $(this).parent('li').addClass 'selected'
    $('.download_path').html $(this).attr('href')
    $('input[type="hidden"][name="path"]').val $(this).attr('href')
    $('span.domain').html $(this).attr('data-root') + '.' if $('span.domain').size() > 0

    # List 表示画面へのリンクのパラメータを書き換え
    href = $('a.list').attr('href').split '?'
    old_params = href[1].split '&'
    new_params = ''
    for o in old_params
      new_params += o + '&' unless o.match /^path\=/
    new_params += 'path=' + encodeURIComponent($(this).attr 'href')
    $('a.list').attr 'href',  href[0] + '?' + new_params
    return false

  $('.file_viewer ul.files li .folder-control').on 'click', ->
    if $(this).hasClass 'folder-open'
      $(this).removeClass 'folder-open'
      $(this).addClass 'folder-close'
      $(this).html "&#9658;"
      $(this).parent('li').children('ul').slideUp 200
    else
      $(this).removeClass 'folder-close'
      $(this).addClass 'folder-open'
      $(this).html "&#9660;"
      $(this).parent('li').children('ul').slideDown 200
    return

  $('#project_register_datetime').on 'change', ->
    if $(this).is ':checked'
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()
    else
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').show()
    return

  if $('#project_register_datetime').size() > 0 and $('#project_register_datetime').is ':checked'
    $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()

