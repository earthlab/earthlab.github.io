---
 layout: archive
 title: Search
 permalink: 
 sitemap: false
 ---

<div class="sidebar notsticky">
     {% include sidebar_home.html %}
</div>

<div id="home-search" class="home">
   <script>
       (function() {
           var cx = '[Your CSE Search ID]';
           var gcse = document.createElement('script');
           gcse.type = 'text/javascript';
           gcse.async = true;
           gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
           '//www.google.com/cse/cse.js?cx=' + cx;
           var s = document.getElementsByTagName('script')[0];
           s.parentNode.insertBefore(gcse, s);
       })();
   </script>
   <gcse:search queryParameterName="searchString"></gcse:search>
</div>
