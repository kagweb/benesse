# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.file_viewer ul.files li a').on 'click', ->
    $('.selected').removeClass 'selected'
    $(this).parent('li').addClass 'selected'
    set_download_path $(this).attr('href')
    set_list_path $(this).attr('href')
    $('span.domain').html $(this).attr('data-root') + '.' if $('span.domain').size() > 0
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

  $('.file_viewer table.files tr').on 'click', ->
    $('tr.selected').removeClass 'selected'
    $(this).addClass 'selected'
    set_download_path $(this).attr('data-path')
    set_list_path $(this).attr('data-path')

  $('.file_viewer .file_action').on 'click', ->
    msg = []
    msg['download'] = false
    msg['upload']   = false
    msg['delete']   = "変更は取り消すことができません。\n削除してもよろしいですか？"
    type = $(this).attr('data-action')
    return Boolean alert('ファイルが選択されていません') unless $('input[type="hidden"][name="path"]').val()
    return confirm msg[type] if msg[type]
#     return download() if type == 'download'

  # List 表示画面へのリンクのパラメータを書き換え
  set_list_path = (path) ->
    href = $('a.list').attr('href').split '?'
    old_params = href[1].split '&'
    new_params = ''
    for o in old_params
      new_params += o + '&' unless o.match /^path\=/
    new_params += 'path=' + encodeURIComponent(path)
    $('a.list').attr 'href',  href[0] + '?' + new_params

  set_download_path = (path) ->
    $('.download_path').html path
    $('input[type="hidden"][name="path"]').val path

  download = ->
    win = window.open()
    win.location.href = '/downloads'
    setTimeout( ->
      win.close()
    , 5000)
    return false

  $('#project_register_datetime').on 'change', ->
    if $(this).is ':checked'
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()
    else
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').show()
    return

  if $('#project_register_datetime').size() > 0 and $('#project_register_datetime').is ':checked'
    $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()

