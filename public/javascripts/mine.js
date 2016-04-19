 $(document).ready(function(){
  $('.field_text').click(function(){
 	$(this).parent().siblings('.field_value').val($(this).attr('value'));
    $('.search_form').submit();
  });
});