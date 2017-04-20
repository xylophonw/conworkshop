class TimeManager
  constructor: (utz) ->
    @tz = @figureOutTz(utz)

  update: ->
    self = this
    $('time[datetime]').each ->
      el  = $(this)
      dt  = el.attr('datetime')
      fmt = self.getFormat(el.data('cws-time-with-time'), el.data('cws-time-long'))
      tz  = if self.isRubyTruthy(el.data('cws-time-local')) then self.tz else 'UTC'

      el.text(moment.utc(dt, moment.ISO_8601).tz(tz).format(fmt))

# ----------- private -----------
  figureOutTz: (utz) ->
    return utz if utz && utz.length != 0

    moment.tz.guess()

  getFormat: (with_time, long) ->
    if long is ''
      'DD MMMM YYYY' + (if with_time is '' then ', HH:mm' else '')
    else
      'DD-MMM-YYYY' + (if with_time is '' then ' HH:mm' else '')

  isRubyTruthy: (value) -> value isnt undefined && value isnt null

time_manager = new TimeManager(window.cws_user_tzinfo)

add_trigger = (el, cntr) ->
  el.on('input', -> cntr.val("#{el.val().length}/#{cntr.data('cws-max')}"))

  el.trigger('input')

add_counter = (el, max) ->
  cntr = $("<input class='cntr' type='text' size='9' value='0/0' readonly data-cws-max='#{max}' />")
  cntr.insertAfter(el)

  return cntr

$(document).on("turbolinks:load", ->
  time_manager.update()

  header_btns = $('.header_btn_home, .header_btn_lang')
  $('nav').stick_in_parent({ parent: 'body' })
    .on('sticky_kit:stick',   -> header_btns.addClass('is_shown'))
    .on('sticky_kit:unstick', -> header_btns.removeClass('is_shown'))

  $('textarea[data-cws-char-limit]').each ->
    el = $(this)
    cntr = add_counter(el, el.data('cws-char-limit'))
    add_trigger(el, cntr)
)

