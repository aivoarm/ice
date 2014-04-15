$(function() {
  $("#booked").click(function(){
   $("#booked").attr('href', function(i, h) {
       var x = prompt("Which OU : ", "BMO")
     return h +  "&ou=" + x;
   });
  });
});