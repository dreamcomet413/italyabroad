$( document ).ready(function() {
// swiper best seller

//Header serch main
$(document).on('click','.head_search form ul li a',function(){
  $('#id').val($(this).attr('ival'));
  $('.head_search form').submit();
});

//header search small
$(document).on('click','.head_search_small form ul li a',function(){
  $('#id').val($(this).attr('ival'));
  $('.head_search form').submit();
});


if (window.innerWidth < 850)  {
	var swiper = new Swiper('#firstSwiper', {
    pagination: '#firstSwiper .swiper-pagination',
    paginationClickable: true,
    nextButton: '.best-seller-wrapper .swiper-button-next',
    prevButton: '.best-seller-wrapper .swiper-button-prev',
    slidesPerView: 1,
    spaceBetween: 0,
    
	});

}else{
  var swiper = new Swiper('#firstSwiper', {
  pagination: '.best-seller-wrapper .swiper-pagination',
  paginationClickable: true,
  nextButton: '.best-seller-wrapper .swiper-button-next',
  prevButton: '.best-seller-wrapper .swiper-button-prev',
  slidesPerView: 4,
  spaceBetween: 30,
    });
  }




//Swiper food counter

if (window.innerWidth < 850)  {
	var swiper = new Swiper('#secondSwiper', {
    pagination: '.food-counter-wrapper .swiper-pagination',
    paginationClickable: true,
    nextButton: '.food-counter-wrapper .swiper-button-next',
    prevButton: '.food-counter-wrapper .swiper-button-prev',
    slidesPerView: 1,
    spaceBetween: 0,
    
	});
} else{
  var swiper = new Swiper('#secondSwiper', {
  pagination: '.food-counter-wrapper .swiper-pagination',
  paginationClickable: true,
  nextButton: '.food-counter-wrapper .swiper-button-next',
  prevButton: '.food-counter-wrapper .swiper-button-prev',
  slidesPerView: 4,
  spaceBetween: 30,
});
}
// swiper Review home page
 var swiper = new Swiper('#thirdSwiper', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        direction: 'vertical',
        nextButton: '.pagi-arrow2 .swiper-button-next',
		prevButton: '.pagi-arrow2 .swiper-button-prev',
		slidesPerView: 1,
		spaceBetween: 30,
  });

//Fourth Swipper
var swiper = new Swiper('#fourthSwiper', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        direction: 'vertical',
        nextButton: '.pagi-arrow2 .swiper-button-next',
		prevButton: '.pagi-arrow2 .swiper-button-prev',
		slidesPerView: 1,
		spaceBetween: 30,
  });

// toggle class on click faq tab
$('.panel-title').on('click', function(e) {
      
      if(!$(this).parent().parent().hasClass('pressed')) {
      	$(".panel-default").removeClass("pressed");
      	$(this).parent().parent().addClass("pressed");
      } else {
      	 $(".panel-default").removeClass("pressed");
      }
       //you can list several class names 
      e.preventDefault();
    });

});
//Range Slider
 $(function() {
    $( "#slider-range" ).slider({
      range: true,
      min: 0,
      max: 30,
      values: [ 5, 25 ],
      slide: function( event, ui ) {
        $( "#amount" ).val( "£" + ui.values[ 0 ] + " - £" + ui.values[ 1 ] );
      }
    });
    $( "#amount" ).val( "£" + $( "#slider-range" ).slider( "values", 0 ) +
      " - £" + $( "#slider-range" ).slider( "values", 1 ) );
  });
// hide close
$(".close-btn").click(function(){
    $(".black-strip").addClass("hide");
});