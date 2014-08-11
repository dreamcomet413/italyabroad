function go_to_paypal(){
	setTimeout(document.forms['paypal'].submit(), 4*1000);
}

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var TopicForm = {
  editNewTitle: function(txtField) {
    $('new_topic').innerHTML = (txtField.value.length > 5) ? txtField.value : 'New Topic';
  }
}

var LoginForm = {
  setToPassword: function() {
    $('openid_fields').hide();
    $('password_fields').show();
  },

  setToOpenID: function() {
    $('password_fields').hide();
    $('openid_fields').show();
  }
}

var EditForm = {
  // show the form
  init: function(postId) {
    $('edit-post-' + postId + '_spinner').show();
    this.clearReplyId();
  },

  // sets the current post id we're editing
  setReplyId: function(postId) {
    $('edit').setAttribute('post_id', postId.toString());
    //$('post_' + postId + '-row').addClassName('editing');
    if($('reply')) $('reply').hide();
  },

  // clears the current post id
  clearReplyId: function() {
    var currentId = this.currentReplyId()
    if(!currentId || currentId == '') return;

    var row = $('post_' + currentId + '-row');
    if(row) row.removeClassName('editing');
    $('edit').setAttribute('post_id', '');
  },

  // gets the current post id we're editing
  currentReplyId: function() {
    return $('edit').getAttribute('post_id');
  },

  // checks whether we're editing this post already
  isEditing: function(postId) {
    if (this.currentReplyId() == postId.toString())
    {
      $('edit').show();
      $('edit_post_body').focus();
      return true;
    }
    return false;
  },

  // close reply, clear current reply id
  cancel: function() {
    this.clearReplyId();
    $('edit').hide()
  }
}

var ReplyForm = {
  // yes, i use setTimeout for a reason
  init: function() {
    EditForm.cancel();
    $('reply').toggle();
    $('post_body').focus();
    // for Safari which is sometime weird
//    setTimeout('$(\"post_body\").focus();',50);
  }
}

var RemoteForm = {
  setup: function() {

    var remote_form_popups = $$("a.remote_form_popup");


    for (var index = 0; index < remote_form_popups.length; ++index) {
      var remote_form_popup = remote_form_popups[index];
      var remote_form_popup_id = "remote_form_popup_"+index;

      remote_form_popup.writeAttribute("id", remote_form_popup_id);

      $(remote_form_popup_id).observe('click', function(event){
        var dialog_id = "remote_form_container";

        if ($(dialog_id) == null) {
          var div_remote_form = document.createElement('span');
          div_remote_form.writeAttribute("class", "form");
          div_remote_form.writeAttribute("id", dialog_id);
          document.body.appendChild(div_remote_form);
        };

        RemoteForm.initialize(dialog_id);

        new Ajax.Updater(dialog_id, $(this).href, {method: 'get'});

        $(dialog_id).persistent_show(); Event.stop(event);

        return false


      });

    };

  },

  initialize: function(dialog_id) {
    new Dialog.Box($(dialog_id), {overlay_color:'#589', opacity_to:0.5, persistent:false});
  }
}

var RemoteAddressFrom = {
  setup: function(path) {
    $('ship_address_form_continue').observe('click', function(event) {
     $('ship_address_form').action = path;
    })
  }
}

var RemotePaymentMethodForm = {
  setup: function() {
    var payment_methods = $$("input.payment_method");

    for (var i=1; i < payment_methods.length+1; i++) {
      var payment_method_id = "payment_method_"+i;

      $(payment_method_id).observe('click', function(event) {
        new Ajax.Updater("form", "/orders/new", {method: 'get', parameters: {payment_method: $(this).value}});
        return false;
      })
    };
  }
}
function display_chef_details(){
   if (document.getElementById('chef').checked == true){
    document.getElementById('chef_details').style.display = 'block';
   }
   else{
       document.getElementById('chef_details').style.display = 'none';
   }
}

function add_prices(){
    var html = ""
    html += "<tr id='product_prices'><td></td><td>"
    html += "<input type='text' value='0' size='20' name='product[price]' id='product_price'>"
    html += "<a href='#' onclick='remove_element(this); return false;'> remove</a></td></tr>"
    document.getElementById("product_prices").insertAdjacentHTML('afterend', html);
    return false;
}

function remove_element(element){
    element.parentNode.parentNode.remove();
    return false;
}

function add_quantities(){
    var html = ""
    html += "<tr class='product_quantities'><td></td><td>"
    html += "<input type='text' value='1' size='3' name='product[quantity]' maxlength='3' id='product_quantity'>"
    html += "<a href='#' onclick='remove_element(this); return false;'> remove</a></td></tr>"
    document.getElementById("product_quantities").insertAdjacentHTML('afterend', html);
    return false;
}

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
  $("#chat_window").submitWithAjax();
})
