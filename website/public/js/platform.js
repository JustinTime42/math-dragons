// Marks the page with the visitor's platform so the matching join path is
// shown first and highlighted. Both paths always stay on the page
// (marketing/website/SPEC.md §4.2). Nothing is stored or sent anywhere.
(function () {
  var ua = navigator.userAgent || '';
  var root = document.documentElement;
  // iPadOS Safari reports a Mac user agent; touch support gives it away.
  var iPad = /Macintosh/.test(ua) && navigator.maxTouchPoints > 1;
  if (/iPhone|iPad|iPod/.test(ua) || iPad) root.setAttribute('data-platform', 'ios');
  else if (/Android/.test(ua)) root.setAttribute('data-platform', 'android');
  // Facebook / Instagram in-app browsers break store hand-offs (§4.3).
  if (/FBAN|FBAV|FB_IAB|FB4A|FBIOS|Instagram/.test(ua)) root.setAttribute('data-inapp', '1');
})();
