import apiClient from "./apiClient";
import $ from 'jquery';

const loginForm = {
  nickname: '',
  password: ''
}

$(document).ready(() => {
  if (apiClient.auth.authenticated()) {
    window.location.href = `/profiles/me`
  }

  $('input').on('change', e => {
    const input = $(e.target);
    loginForm[input.attr('name')] = input.val();
  });

  
  $('#login').on('click', e => {
    apiClient.auth.login(loginForm, (res, status) => {
      if (status == 'error') { 
        $('#message').empty();
        $('#message').text(res.responseJSON.errors[0])
        return;
      }
      
      window.location.href = `/profiles/me`;
    })
  });
});