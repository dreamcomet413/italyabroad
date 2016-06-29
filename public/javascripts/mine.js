 $(document).ready(function(){
 	var filters = []	
  $('.field_text').click(function(){
 	$(this).parent().siblings('.field_value').val($(this).attr('value'));
 	var parent_name = $(this).parent().siblings('.field_value').attr('name');
 	filters = $('.selected-filters').find('.' + parent_name)
 	if (filters.length > 0) {
 		$('.selected-filters span.'+parent_name).html($(this).html());
 	}else{
 		// $('.selected-filters').append("<div class='"+parent_name+"'></div>");
 		// $('.selected-filters div.'+parent_name).append("<span class='"+ parent_name + "' >" + $(this).html() + "</span>" ) ;
 		// $('.selected-filters div.'+parent_name).append("<span class='pull-right'><a href='#.' class='close-btn'>X</a></span> <br/>")
  	}
 	// $('.selected-filters').show();
 	$('.search_form').submit();
 	
  });

  $(document).on('click', ".close-btn", function(){
  	$('#'+$(this).attr('target')).val('');
  	$('.search_form').submit();
  	event.preventDefault();
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
 $(document).on('click', '.close-btn', function(){
 	parent_name = $('.close-btn').parent().parent().attr('class');
	$('.panel-body').find('ul input#'+parent_name).attr('value', '')
	$(this).parent().parent('div').remove();
	if ($('.selected-filters').children().length == 0){
		$('.selected-filters').hide();
	}
});
  