// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
ä = jQuery
jQuery(function  () {
  
  var a = ä('li')
  for (i = 1;i<a.length;i++) {
    if (ä(a[i]).width() < 80) ä(a[i]).text("");
  }
  
})