 $(document).ready(function(){
  
  $('.field_text').click(function(){
 	$(this).parent().siblings('.field_value').val($(this).attr('value'));
    $('.search_form').submit();
  });
  $('.submit_cart_form').click(function(){
  	
  	quantity = $(this).parent().siblings('.seller-field').find('.quantity').val();
  	
  	formValues = $(this).parents('form:first').serialize();
	  $.post({
	    url: '/site/cart.js' ,
	    type: 'POST',
	    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
	     data: formValues,
	  });
	});
});

