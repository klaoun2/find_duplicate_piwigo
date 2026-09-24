{literal}
<style>
.fd-panel { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 20px; }
.fd-btn { padding: 10px 15px; border-radius: 5px; background: #0073aa; color: #fff; border: none; cursor: pointer; font-size: 14px; }
.fd-btn:hover { background: #005177; }
.fd-btn:disabled { background: #ccc; cursor: not-allowed; }
.fd-progress-container { margin-top: 15px; height: 20px; background: #f0f0f0; border-radius: 10px; overflow: hidden; display: none; }
.fd-progress-bar { height: 100%; background: #4caf50; width: 0%; transition: width 0.3s ease; }
</style>
{/literal}

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
<div class="fd-panel">
  <h3>Znalezione duplikaty</h3>
  {if count($FD_DUPLICATES) > 0}
    <p>Znaleziono {count($FD_DUPLICATES)} grup powiązanych zdjęć.</p>
    
    <div class="fd-duplicates-list">
      {foreach from=$FD_DUPLICATES item=group}
        <div style="border: 1px solid #ddd; margin-bottom: 20px; padding: 15px; border-radius: 5px;">
          <h4>Hash: {$group.PHASH}</h4>
          <div style="display: flex; gap: 15px; flex-wrap: wrap;">
            {foreach from=$group.IMAGES item=img}
              <div style="width: 150px; text-align: center;">
                <a href="{$img.URL}" target="_blank">
                  <img src="{$img.PATH}" style="max-width: 100%; height: auto; border: 1px solid #ccc; border-radius: 4px;" alt="{$img.NAME}">
                </a>
                <div style="font-size: 11px; margin-top: 5px; word-break: break-all;">
                  ID: {$img.ID}<br>
                  {$img.FILE}
                </div>
              </div>
            {/foreach}
          </div>
        </div>
      {/foreach}
    </div>
  {else}
    <p>Nie znaleziono żadnych duplikatów.</p>
  {/if}
</div>
{/if}
