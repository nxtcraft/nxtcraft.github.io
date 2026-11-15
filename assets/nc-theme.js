(function () {
  var KEY = 'nc_theme', root = document.documentElement;
  var icon = function () { return root.getAttribute('data-theme') === 'dark' ? '☀️' : '🌙'; };
  var btn = document.createElement('button');
  btn.id = 'nc-dm';
  btn.type = 'button';
  btn.title = 'Toggle dark mode';
  btn.setAttribute('aria-label', 'Toggle dark mode');
  btn.style.cssText = 'position:fixed;bottom:72px;right:14px;z-index:9999;width:40px;height:40px;border-radius:50%;border:1px solid rgba(255,255,255,.15);cursor:pointer;font-size:18px;background:rgba(0,0,0,.5);backdrop-filter:blur(6px);box-shadow:0 2px 10px rgba(0,0,0,.3)';
  btn.textContent = icon();
  btn.addEventListener('click', function () {
    var t = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', t);
    try { localStorage.setItem(KEY, t); } catch (e) {}
    btn.textContent = icon();
  });
  document.body.appendChild(btn);
})();
