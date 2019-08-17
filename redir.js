(function () {
  var languages = navigator.languages;
  for (var i = 0; i < languages.length; ++i) {
    var lang = languages[i];
    var m = lang.match(/^(ko|en)(-|$)/);
    if (m) {
      location.href = '../' + m[1] + '/' + 
        (location.protocol == 'file:' ? 'index.html' : '');
      break;
    }
  }
})();
