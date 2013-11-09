# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('body').on 'click', '.file_viewer ul.files li a', ->
    $('.selected').removeClass 'selected'
    $(this).parent('li').addClass 'selected'
    set_download_path $(this).attr('href')
    set_list_path $(this).attr('href')
    $('span.domain').html $(this).attr('data-root') + '.' if $('span.domain').size() > 0
    return false

  $('body').on 'click', '.file_viewer ul.files li .folder-control', ->
    if $(this).hasClass 'folder-opened'
      $(this).removeClass 'folder-opened'
      $(this).addClass 'folder-closed'
      $(this).html "&#9658;"
      $(this).parent('li').children('ul').slideUp 200
      $(this).parent('li').children('ul').empty()
    else
      $target = $(this).parent 'li'
      $loading = $target.children('a').append ' <img src="/assets/loader.gif">'

      $.ajax
        url: '/api/file_structure',
        type: 'post',
        data:
          path: $target.children('a').attr 'href'
        dataType: 'json',
        success: (res) ->
          for r in res
            filename = r.file[0]
            fileinfo = r.file[1]

            if fileinfo.type == 'dir'
              tag = '<li>'
              tag += '<span class="folder-control folder-closed">&#9658;</span>'
              tag += '<a href="' + fileinfo.basepath + '/' + fileinfo.path + '" data-root="' + fileinfo.root + '">' + '<i class="icon-folder-close"></i> ' + filename + '</a>'
              tag += '<ul class="unstyled"></ul>'
              tag += '</li>'
            else
              tag = '<li class="file">'
              tag += '<a href="' + fileinfo.basepath + '" data-root="' + fileinfo.root + '">' + '<i class="icon-file"></i> ' + filename + '</a>'
              tag += '<div class="pull-right span2 file_info">' + fileinfo.updated_at + '</div>'
              tag += '<div class="pull-right span1 file_info">' + fileinfo.size + '</div>'
              tag += '<div class="pull-right span1 file_info">' + fileinfo.type + '</div>'
              tag += '</li>'
            $target.children('ul').append tag
          $loading.children('img').remove();
        ,
        error: (xhr, status, error) ->
          console.log xhr
          console.log status
          console.log error

      $(this).removeClass 'folder-closed'
      $(this).addClass 'folder-opened'
      $(this).html "&#9660;"
      $target.children('ul').slideDown 200
    return

  $('body').on 'click', '.file_viewer table.files tr', ->
    $('tr.selected').removeClass 'selected'
    $(this).addClass 'selected'
    set_download_path $(this).attr('data-path')
    set_list_path $(this).attr('data-path')

  $('body').on 'click', '.file_viewer .file_action', ->
    msg = []
    msg['download'] = false
    msg['upload']   = false
    msg['delete']   = "変更は取り消すことができません。\n削除してもよろしいですか？"
    type = $(this).attr('data-action')
    return Boolean alert('ファイルが選択されていません') unless $('input[type="hidden"][name="path"]').val()
    return confirm msg[type] if msg[type]
    $(this).html $(this).children('i')
    $(this).append ' ' + (type.charAt(0).toUpperCase() + type.slice(1)).replace(/e$/, '') + 'ing <img src="/assets/loader.gif">'
    $(this).addClass 'disabled'
    return download() if type == 'download'

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
    $('.preview_link').attr('href', $('.preview_link').attr('base_url') + path)
    $('.download_path').html path
    $('input[type="hidden"][name="path"]').val path

  download = ->
    $.ajax
      url: '/downloads/get_url',
      type: 'post',
      data:
        path: $('input[type="hidden"][name="path"]').val()
      dataType: 'json',
      success: (res) ->
        if res['result']
          win = window.open()
          win.location.href = res['url']
          setTimeout( ->
            win.close()
            location.reload()
          , 3000)
        else
          $('button[name="download"]').removeClass('disabled').html($('button[name="download"]').children('i')).append(' ダウンロード')
          alert res['error']
      ,
      error: ->
        $('button[name="download"]').removeClass('disabled').html($('button[name="download"]').children('i')).append(' ダウンロード')
        alert('ダウンロードに失敗しました。\nリロード後、再度ダウンロードしてください。');
    return false

  $('#project_register_datetime').on 'change', ->
    if $(this).is ':checked'
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()
    else
      $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').show()
    return

  if $('#project_register_datetime').size() > 0 and $('#project_register_datetime').is ':checked'
    $('#project_production_upload_at_3i, #project_production_upload_at_4i, #project_production_upload_at_5i, .separator').hide()

