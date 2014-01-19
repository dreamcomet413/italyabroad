var i = 0;
var current_index;
var play;
var image_slide = new Array('#home_image_1', '#home_image_2', '#home_image_3', '#home_image_4', '#home_image_5');
var NumOfImages = image_slide.length;
//var wait = 4000;
var wait = 10000;

function SwapImage(x,y) {
  $(image_slide[x]).show({duration:0.5});
  $(image_slide[y]).hide({duration:0.5});
}

function StartSlideShow() {
  play = setInterval('Play()', wait);
  $('PlayButton').hide();
  $('PauseButton').show({duration:0});
  // update_active_link();
}

function Play() {
  var imageShow, imageHide;
  imageShow = i + 1;imageHide = i;
  if (imageShow == NumOfImages) {
    SwapImage(0, imageHide);
    i = 0;
  } else {
    SwapImage(imageShow, imageHide);
    i++;
  }
  // var textIn = i + 1 + ' of ' + NumOfImages;
  current_index = i+1;
  update_active_link(current_index);
}

function Stop() {
  clearInterval(play);
  $('PlayButton').show({duration:0});
  $('PauseButton').hide();
}

function GoTo(active_image_id) {
  var last_index = i;
  var active_index = image_slide.indexOf(active_image_id);

  Stop();

  if (last_index != active_index) {
    SwapImage(active_index,last_index);
    update_active_link(active_index + 1);
    i = active_index;
  }
}

function GoNext() {
  clearInterval(play);
  $('PlayButton').show({duration:0});
  $('PauseButton').hide();

  var imageShow, imageHide;imageShow = i+1;imageHide = i;

  if(imageShow == NumOfImages){
    SwapImage(0,imageHide);
    i=0;
  } else {
    SwapImage(imageShow, imageHide);
    i++;
  }
  update_active_link();
}

function GoPrevious(){
  clearInterval(play);
  $('PlayButton').show({duration:0});
  $('PauseButton').hide();
  var imageShow, imageHide;imageShow = i-1;imageHide = i;

  if (i == 0) {
    SwapImage(NumOfImages - 1, imageHide);
    i = NumOfImages - 1;
  } else {
    SwapImage(imageShow, imageHide);
    i--;
  }
  update_active_link();
}

/*function update_active_link(current_index){

 var active_image_id = 'link_home_image_' + current_index;
  for (var the_id = NumOfImages; the_id > 0; the_id--){
    var image_id = 'link_home_image_' + the_id;
    var number_id = 'link_number_'+ the_id;

    if (image_id == active_image_id) {
      $(image_id).writeAttribute('class', 'active');
      $(number_id).writeAttribute('class', 'white_text_select');
     //$(number_id).addClassName('white_text_select');
    } else {
      $(image_id).writeAttribute('class', 'inactive');
      $(number_id).writeAttribute('class', 'white_text');
    };
  };
    }*/


 function update_active_link(current_index){
    var active_image_id = '#link_home_image_' + current_index;

    for (var the_id = NumOfImages; the_id > 0; the_id--){
        var image_id = '#link_home_image_' + the_id;
        var number_id = '#link_number_'+ the_id;

        if (image_id == active_image_id) {
            var classArray = $(image_id).find('a').attr('class').split(' ')
            for (var index = 0, len = classArray.length; index < len; ++index) {
                $(image_id).removeClass(classArray[index]);
            }
            $(image_id).addClass('active');
            //$(number_id).addClassName('white_text_select');

            var classArray1 = $(number_id).attr('class').split(' ')
            for (var index1 = 0, len1 = classArray1.length; index1 < len1; ++index1) {
                $(number_id).removeClass(classArray1[index1]);
            }
            $(number_id).addClass('white_text_select');

        } else {
            var classArray = $(image_id).find('a').attr('class').split(' ')
            for (var index = 0, len = classArray.length; index < len; ++index) {
                $(image_id).removeClass(classArray[index]);
            }
            $(image_id).addClass('inactive');
            var classArray1 = $(number_id).attr('class').split(' ')
            for (var index1 = 0, len1 = classArray1.length; index1 < len1; ++index1) {
                $(number_id).removeClass(classArray1[index1]);
            }
            $(number_id).addClass('white_text');
        };
    };

}

