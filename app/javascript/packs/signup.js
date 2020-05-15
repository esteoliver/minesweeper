import apiClient from "./apiClient";
import $ from 'jquery';

const signupForm = {
  email: '',
  nickname: '',
  password: ''
}

$(document).ready(() => {
  if (apiClient.auth.authenticated()) {
    window.location.href = `/profiles/me`
  }

  $('input').on('change', e => {
    const input = $(e.target);
    signupForm[input.attr('name')] = input.val();
  });

  
  $('#signup').on('click', e => {
    console.log(signupForm)
    // apiClient.auth.register(signupForm, (res, status) => {
    //   if (status == 'error') { 
    //     $('#message').empty();
    //     $('#message').text(res.responseJSON.errors.full_messages.join(', '))
    //     return;
    //   }
      
    //   window.location.href = '/profiles/me';
    // })
  });
});