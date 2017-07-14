/* this allows us to pass in HTML tags to autocomplete. Without this they get escaped */
$[ "ui" ][ "autocomplete" ].prototype["_renderItem"] = function( ul, item) {
return $( "<li></li>" ) 
  .data( "item.autocomplete", item )
  .append( $( "<a></a>" ).html( item.label ) )
  .appendTo( ul );
};