function onTestChange() {
    var key = window.event.keyCode;

    // If the user has pressed enter
    if (key == 13) {
      if ($(".home-page-message-text-area").val().trim() == "")
        return false
      else
        $(".message-send-button").click();
}}


function isNumberKey(evt)
       {
          var charCode = (evt.which) ? evt.which : evt.keyCode;
          if (charCode != 46 && charCode > 31 
            && (charCode < 48 || charCode > 57))
             return false;

          return true;
       }

