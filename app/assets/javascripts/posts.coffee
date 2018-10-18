# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# after the DOM loads, get all the comments for the given Post
$(document).on 'turbolinks:load', ->
  a = location.pathname.split("/");
  if $("#post-container").length > 0
    post_id = $("#post-container").attr("data-post-id")
    $.ajax
      url:  "/posts/" + post_id + "/comments"
      type: 'GET'
      success: (data, textStatus, jqXHR) ->
        render_comments(data, post_id)

# loops through all the Comments for a Post and displays them in a list
render_comments = (data, post_id) ->
  comment_list = $("#comment-list")
  comment_list.empty()
  for comment in data
    comment_list.append(get_comment_html(comment["comment"], comment["id"], post_id))

# returns the HTML markup for a single Comment
get_comment_html = (comment_content, comment_id, post_id) ->
  new_comment = '
    <div class="row container" id="comment-row-'+comment_id+'">
      <p><span id="data-comment-text-'+comment_id+'">'+comment_content+'</span>
        <br>
        <span>
          &nbsp
          <button class="btn-primary btn-sml edit-comment-button"
            data-post-id="'+post_id+'" data-comment-id="'+comment_id+'">
            Edit
          </button>
          &nbsp
        </span>
        <span>
          <button class="btn-dark btn-sml delete-comment-button"
            data-post-id="'+post_id+'" data-comment-id="'+comment_id+'">
            Delete
          </button>
        </span>
      </p>
    </div>'
  return new_comment

# edit a Comment, then update the back end and also the Comment List
$(document).on "click", ".edit-comment-button", (e) ->
  e.preventDefault()
  element = $(this)
  post_id = element.attr("data-post-id")
  comment_id = element.attr("data-comment-id")
  full_element = $("#comment-row-" + comment_id)
  comment_content = $("#data-comment-text-" + comment_id).text()
  full_element.empty()
  new_editor = '<textarea class="form-control" rows="2" required="" id="data-comment-text-'+comment_id+'">'+comment_content+'</textarea> <button class="btn-primary btn-xs save-comment-button" rel="nofollow" data-post-id="'+post_id+'" data-comment-id="'+comment_id+'"> Save </button>'
  full_element.append(new_editor)

# edit a Comment, then update the back end and also the Comment List
$(document).on "click", ".save-comment-button", (e) ->
  e.preventDefault()
  element = $(this)
  post_id = element.attr("data-post-id")
  comment_id = element.attr("data-comment-id")
  full_element = $("#comment-row-" + comment_id)
  comment_content = $("#data-comment-text-" + comment_id).val()
  full_element.empty()
  $.ajax
    url:  "/posts/" + element.attr("data-post-id") + "/comments/" + element.attr("data-comment-id") + '/edit'
    type: 'GET'
    data: {comment: comment_content}
    success: (data, textStatus, jqXHR) ->
      full_element.append(get_comment_html(comment_content, comment_id, post_id))
    error: (jqXHR, textStatus, errorThrown) ->
      alert("Server error; could not save editted comment. Please try again later.")

# delete a Comment from the back end and also in the Comment List
$(document).on "click", ".delete-comment-button", (e) ->
  e.preventDefault()
  element = $(this)
  post_id = element.attr("data-post-id")
  comment_id = element.attr("data-comment-id")
  full_element = $("#comment-row-" + comment_id)
  $.ajax
    url:  "/posts/" + post_id + "/comments/" + comment_id
    type: 'DELETE'
    success: (data, textStatus, jqXHR) ->
      full_element.remove()
    error: (jqXHR, textStatus, errorThrown) ->
      alert("Server error; could not remove comment. Please try again later.")

# add a new Comment to the back end and also adds it to the Comment List
$(document).on "click", "#add-comment-button", (e) ->
  e.preventDefault()
  comment_content = $('#comment-content').val()
  post_id = $("#post-container").attr("data-post-id")
  $.ajax
    url:  "/posts/" + post_id + "/comments"
    type: 'POST'
    data: {comment: comment_content}
    success: (data, textStatus, jqXHR) ->
      new_comment = get_comment_html(comment_content, data["comment_id"], data["post_id"])
      $("#comment-list").prepend(new_comment)
      $('#comment-content').val("")
    error: (jqXHR, textStatus, errorThrown) ->
      # message to tell user about an error that occurred
      errors = jQuery.parseJSON( jqXHR.responseText )
