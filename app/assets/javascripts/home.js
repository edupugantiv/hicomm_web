// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require jquery.readyselector
//= require_tree ./common



  function initialize() {
    var position = new google.maps.LatLng(38.0527378,-78.5135903);
    var myOptions = {
      zoom: 10,
      center: position,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(
        document.getElementById("contact-us-map"),
        myOptions);
 
    var marker = new google.maps.Marker({
        position: position,
        map: map,
        title:"Hicomm"
    });  
 
    var contentString = '<strong>Hicomm</strong>';
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
 
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map,marker);
    });


  }
 

function isMobile(evt)
{
  var charCode = (evt.which) ? evt.which : evt.keyCode;
  if (charCode != 46 && charCode !=43 && charCode > 31 
    && (charCode < 48 || charCode > 57))
     return false;

  return true;
} 

function terms(event){
  if ($('#TermsOfService').prop('checked') == true){
    $('#submit-registration-form').removeAttr('disabled');
   }

  if ($('#TermsOfService').prop('checked') == false){
    $('#submit-registration-form').attr('disabled','disabled');
   }

}



function addSignupFields() {
  user_count = $('#mass_user_count').val()
  new_user_number = parseInt(user_count) + 1
  new_fields = "<div class='mass-signup-row row'><div class='col-md-1'></div><div class='col-md-1'><div class='mass-signup-index'>"+ new_user_number +"</div></div><div class='col-md-2'><input type='text' name='first_name_" + new_user_number +  "' id='name-" + new_user_number + "' class='form-control' placeholder='Name' required='required'></div>  <div class='col-md-2'><input type='text' name='mobile_" + new_user_number +"' id='mobile-" + new_user_number + "' class='form-control'   placeholder='Mobile' required='required' onkeypress= 'return isMobile(event)'></div>   <div class='col-md-2'><input type='password' name='password_" + new_user_number + "' id='password-" + new_user_number + "' class='form-control'    placeholder='Password' required='required'></div>    <div class='col-md-2'><input type='password' name='confirm_password_" + new_user_number + "' id='confirm-password-" + new_user_number + "' class='form-control'     placeholder='Confirm Password' required='required'></div></div>" 
  $('#mass_user_count').val(new_user_number)
  $('.mass-signup-group').append(new_fields)
}



// Commented temporaralily, uncomment it after clickatell starts working.
// function terms(event)
// {
//   if ($('#TermsOfService').prop('checked') == true)
//   {
//     if ($('#authentication-code-error').val() == 'true')
//     {
//         $('#submit-registration-form').removeAttr('disabled');
//     }
//   }
//   if ($('#TermsOfService').prop('checked') == false)
//   {
//     $('#submit-registration-form').attr('disabled','disabled');
//   }
// }


function sendAuthenticationCode() {

  var phoneNumber = $('#signup-user-mobile').val();
  var countryCode = $('#user_country').val();
  if (phoneNumber.length == 10)
  {
      $.ajax({
        data: {phoneNumber: phoneNumber, countryCode: countryCode},
        type: 'post',
        url: '/welcome/send_authentication_code', 
        success: function(response) {
          $('#send-authentication-code-error').text('');          
          $('#authentication-code-error').text('');          
          if (response.status == 'success')
          {
            $('.send-authentication-code-block').fadeOut(500);
            $('.authenticate-code-block').removeClass('hide');
            $('.authenticate-code-block').fadeIn(500);
            $('#authentication-code-error').css('color', 'green');
            $('#authentication-code-error').text('Please enter the recieved code.');          
          }
          else
          {
            $('#send-authentication-code-error').css('color', 'red');
            $('#send-authentication-code-error').text(response.message)          
          }
        }
      });
  }
  else
  {
    $('#send-authentication-code-error').css('color', 'red');
    $('#send-authentication-code-error').text('Please enter a valid mobile number.')
    return false;
  }
}


function authenticateCode() {

    var code = $('#code').val();
    var phoneNumber = $('#signup-user-mobile').val();
    var countryCode = $('#user_country').val();

    $.ajax({
      data: {phoneNumber: phoneNumber,countryCode: countryCode,code: code},
      type: 'post',
      url: '/welcome/authenticate_code',
      success: function(response) {
        if (response.status == 'success')
        {
          $('#authentication-code-error').val('true')
          $('.authenticate-code-block').addClass('hide');
          $('#authentication-code-error').css('color', 'green');
          $('#authentication-code-error').text('Success');

          if ($('#TermsOfService').prop('checked') == true)
            {
              $('#submit-registration-form').removeAttr('disabled');
            }
        }


      else
      {
          $('#authentication-code-error').css('color', 'red');
          $('#authentication-code-error').text('Wrong code. Please try again.')
      }
    }

})}
