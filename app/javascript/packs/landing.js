import apiClient from "./apiClient";
import $ from 'jquery';

$(document).ready(() => {
  if (apiClient.auth.authenticated()) {
    window.location.href = `/profiles/me`
  }
});
