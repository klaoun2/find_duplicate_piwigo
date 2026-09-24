{literal}
<style>
#fd-main { max-width: 1300px; color: inherit; }
#fd-main .fd-panel { 
  background: rgba(128,128,128,.08); 
  padding: 20px; 
  border-radius: 10px; 
  border: 1px solid rgba(128,128,128,.3); 
  margin-bottom: 20px;
  backdrop-filter: blur(4px);
}
#fd-main .fd-panel h3 { margin-top: 0; font-size: 1.2em; }
#fd-main .fd-btn { 
  padding: 8px 14px; 
  border-radius: 6px; 
  border: 1px solid rgba(90,150,220,.5); 
  background: rgba(90,150,220,.12); 
  color: inherit; 
  cursor: pointer; 
  font-size: 14px; 
}
#fd-main .fd-btn:hover { background: rgba(90,150,220,.25); }
#fd-main .fd-btn:disabled { background: rgba(128,128,128,.1); border-color: rgba(128,128,128,.2); cursor: not-allowed; opacity: 0.6; }
#fd-main .fd-progress-container { margin-top: 15px; height: 15px; background: rgba(128,128,128,.15); border-radius: 8px; overflow: hidden; display: none; }
#fd-main .fd-progress-bar { height: 100%; background: rgba(90,160,90,.8); width: 0%; transition: width 0.3s ease; }
#fd-main .fd-group { border: 1px solid rgba(128,128,128,.3); margin-bottom: 20px; padding: 15px; border-radius: 10px; background: rgba(128,128,128,.04); }
#fd-main .fd-group h4 { margin-top: 0; }
#fd-main .fd-img-wrap { width: 150px; text-align: center; }
#fd-main .fd-img-wrap img { max-width: 100%; height: auto; border: 1px solid rgba(128,128,128,.4); border-radius: 6px; }
#fd-main .fd-img-wrap .fd-img-info { font-size: 11px; margin-top: 5px; word-break: break-all; opacity: 0.8; }
#fd-main .fd-toolbar { 
  display: flex; flex-wrap: wrap; gap: 15px; align-items: center; 
  padding: 10px 15px; margin-bottom: 20px; 
  border: 1px solid rgba(128,128,128,.3); border-radius: 10px; 
  background: rgba(128,128,128,.08); backdrop-filter: blur(4px); 
}
#fd-main .fd-toolbar label { display: inline-flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; }
#fd-main input[type=range] { vertical-align: middle; }
#fd-main .fd-warning { color: #d9534f; font-size: 13px; font-weight: bold; display: none; margin-top: 5px; }

#fd-main .fd-pagination { display: flex; justify-content: center; gap: 10px; padding: 20px 0; align-items: center; }
#fd-main .fd-pagination a, #fd-main .fd-pagination span { 
  padding: 8px 12px; 
  border-radius: 6px; 
  background: rgba(128,128,128,.1); 
  border: 1px solid rgba(128,128,128,.3); 
  text-decoration: none; 
  color: inherit; 
}
#fd-main .fd-pagination a:hover { background: rgba(90,150,220,.2); border-color: rgba(90,150,220,.5); }
#fd-main .fd-pagination span.fd-current { background: rgba(90,150,220,.5); font-weight: bold; }
</style>
{/literal}

<div id="fd-main">

<div class="titrePage">
  <h2>Wyszukiwarka Duplikatów</h2>
</div>

<div class="fd-panel">
  <h3>Stan skanowania galerii</h3>
  <p>Aby móc skutecznie wyszukiwać duplikaty, wtyczka musi najpierw wygenerować hash (odcisk palca) dla każdego zdjęcia w Twojej galerii.</p>
  
  <p>
    Przeskanowanych zdjęć: <strong id="fd-hashed">{$FD_HASHED_IMAGES}</strong> / <strong id="fd-total">{$FD_TOTAL_IMAGES}</strong>
  </p>
  
  <button id="fd-scan-btn" class="fd-btn" {if $FD_HASHED_IMAGES >= $FD_TOTAL_IMAGES && $FD_TOTAL_IMAGES > 0}disabled{/if}>
    Skanuj galerię
  </button>
  
  <div class="fd-progress-container" id="fd-progress-container">
    <div class="fd-progress-bar" id="fd-progress-bar"></div>
  </div>
</div>

<script type="text/javascript">
var pwgToken = "{$PWG_TOKEN}";
var actionUrl = "{$FD_ACTION_URL}";
var isScanning = false;

document.getElementById('fd-scan-btn').addEventListener('click', function() {
  if (isScanning) return;
  isScanning = true;
  this.disabled = true;
  this.innerText = 'Skanowanie w toku...';
  document.getElementById('fd-progress-container').style.display = 'block';
  scanChunk();
});

function scanChunk() {
  var url = actionUrl + '&action=scan&pwg_token=' + pwgToken;
  
  fetch(url)
    .then(response => response.json())
    .then(data => {
      document.getElementById('fd-hashed').innerText = data.hashed;
      document.getElementById('fd-total').innerText = data.total;
      
      var percent = data.total > 0 ? (data.hashed / data.total) * 100 : 0;
      document.getElementById('fd-progress-bar').style.width = percent + '%';
      
      if (!data.done) {
        scanChunk();
      } else {
        isScanning = false;
        document.getElementById('fd-scan-btn').innerText = 'Skanowanie zakończone';
        location.reload(); // Przeładuj, by pokazać duplikaty
      }
    })
    .catch(error => {
      console.error('Error during scan:', error);
      alert('Wystąpił błąd podczas skanowania. Spróbuj odświeżyć stronę.');
      isScanning = false;
      document.getElementById('fd-scan-btn').innerText = 'Wznów skanowanie';
      document.getElementById('fd-scan-btn').disabled = false;
    });
}
</script>

{if $FD_HASHED_IMAGES >= $FD_TOTAL_IMAGES && $FD_TOTAL_IMAGES > 0}

<form id="fd-filter-form">
  <div class="fd-toolbar">
    <label>
      Podobieństwo: 
      <input type="range" id="fd-similarity-range" min="80" max="100" value="{$FD_SIMILARITY}" oninput="document.getElementById('fd-sim-val').innerText = this.value + '%'">
      <span id="fd-sim-val">{$FD_SIMILARITY}%</span>
    </label>
    
    <label>
      <input type="checkbox" id="fd-same-album-chk" value="1" {if $FD_SAME_ALBUM}checked{/if}>
      Szukaj tylko w tym samym albumie
    </label>
    
    <button type="submit" class="fd-btn">Zastosuj</button>
  </div>
  <div class="fd-warning" id="fd-warning-msg"></div>
</form>

<script type="text/javascript">
(function(){
  var actionUrl = "{$FD_ACTION_URL}";
  var totalImages = {$FD_TOTAL_IMAGES};
  var chk = document.getElementById('fd-same-album-chk');
  var warnMsg = document.getElementById('fd-warning-msg');
  var form = document.getElementById('fd-filter-form');
  
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      var sim = document.getElementById('fd-similarity-range').value;
      var sameAlbum = chk.checked ? 1 : 0;
      window.location.href = actionUrl + '&similarity=' + sim + '&same_album=' + sameAlbum;
    });
  }
  
  function updateWarning() {
    if (!chk.checked) {
      var comparisons = (totalImages * (totalImages - 1)) / 2;
      var compStr = comparisons.toLocaleString();
      warnMsg.innerText = 'Uwaga: Wyłączono szukanie w tym samym albumie. Zostanie wykonanych ok. ' + compStr + ' porównań. To może zająć dłuższą chwilę i obciążyć serwer.';
      warnMsg.style.display = 'block';
    } else {
      warnMsg.style.display = 'none';
    }
  }
  
  if (chk) {
    chk.addEventListener('change', updateWarning);
    updateWarning(); // init
  }
})();
</script>

<div class="fd-panel">
  <h3>Znalezione duplikaty</h3>
  {if count($FD_DUPLICATES) > 0}
    <p>Znaleziono {$FD_TOTAL_GROUPS} grup powiązanych zdjęć. Strona {$FD_CURRENT_PAGE} z {$FD_TOTAL_PAGES}.</p>
    
    <div class="fd-duplicates-list">
      {foreach from=$FD_DUPLICATES item=group}
        <div class="fd-group">
          <h4>{$group.TITLE} <span style="font-size: 11px; opacity: 0.6; font-weight: normal;">(Hash: {$group.PHASH})</span></h4>
          <div style="display: flex; gap: 15px; flex-wrap: wrap;">
            {foreach from=$group.IMAGES item=img}
              <div class="fd-img-wrap">
                <a href="{$img.URL}" target="_blank">
                  <img src="{$img.PATH}" alt="{$img.NAME}">
                </a>
                <div class="fd-img-info">
                  ID: {$img.ID}<br>
                  {$img.FILE}
                </div>
              </div>
            {/foreach}
          </div>
        </div>
      {/foreach}
    </div>
    
    {if $FD_TOTAL_PAGES > 1}
    <div class="fd-pagination">
      {if $FD_CURRENT_PAGE > 1}
        <a href="{$FD_ACTION_URL}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&p={$FD_CURRENT_PAGE-1}">Poprzednia</a>
      {/if}
      
      {for $p=max(1, $FD_CURRENT_PAGE-3) to min($FD_TOTAL_PAGES, $FD_CURRENT_PAGE+3)}
        {if $p == $FD_CURRENT_PAGE}
          <span class="fd-current">{$p}</span>
        {else}
          <a href="{$FD_ACTION_URL}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&p={$p}">{$p}</a>
        {/if}
      {/for}
      
      {if $FD_CURRENT_PAGE < $FD_TOTAL_PAGES}
        <a href="{$FD_ACTION_URL}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&p={$FD_CURRENT_PAGE+1}">Następna</a>
      {/if}
    </div>
    {/if}
    
  {else}
    <p>Nie znaleziono żadnych duplikatów.</p>
  {/if}
</div>
{/if}

</div> <!-- /#fd-main -->
