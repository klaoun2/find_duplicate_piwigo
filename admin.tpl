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

#fd-main .fd-group { cursor: pointer; transition: background 0.2s, opacity 0.3s ease; opacity: 1; }
#fd-main .fd-group.fd-fading-out { opacity: 0; pointer-events: none; }
#fd-main .fd-group:hover { background: rgba(128,128,128,.1) !important; }

/* Modal CSS */
#fd-modal { display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.8); backdrop-filter: blur(5px); overflow: auto; opacity: 0; transition: opacity 0.3s ease; }
#fd-modal.fd-modal-show { opacity: 1; }
#fd-modal-content { background: var(--theme-bg, #222); color: var(--theme-color, #eee); margin: 5% auto; padding: 20px; border-radius: 10px; width: 90%; max-width: 1200px; position: relative; border: 1px solid rgba(128,128,128,.3); box-shadow: 0 5px 15px rgba(0,0,0,0.5); opacity: 0; transform: translateY(-40px); transition: opacity 0.3s ease, transform 0.3s ease; }
#fd-modal.fd-modal-show #fd-modal-content { opacity: 1; transform: translateY(0); }
#fd-modal.fd-modal-closing { opacity: 0; }
#fd-modal.fd-modal-closing #fd-modal-content { opacity: 0; transform: translateY(-40px); }
#fd-modal-close { position: absolute; right: 20px; top: 15px; font-size: 28px; font-weight: bold; cursor: pointer; opacity: 0.7; }
#fd-modal-close:hover { opacity: 1; }
.fd-modal-images { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; justify-content: center; }
.fd-modal-img-wrap { text-align: center; background: rgba(128,128,128,.1); padding: 15px; border-radius: 8px; border: 1px solid rgba(128,128,128,.3); max-width: 45%; flex-grow: 1; transition: opacity 0.3s ease, transform 0.3s ease, max-width 0.3s ease, padding 0.3s ease, margin 0.3s ease, border-width 0.3s ease, flex-grow 0.3s ease; transform-origin: top center; overflow: hidden; }
.fd-modal-img-wrap.fd-collapsing { opacity: 0; transform: scale(0.8); max-width: 0; padding-left: 0; padding-right: 0; margin-left: 0; margin-right: 0; border-width: 0; flex-grow: 0.0001; }
.fd-modal-img-wrap img { max-width: 100%; max-height: 50vh; object-fit: contain; border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.3); }
.fd-modal-img-info { margin: 15px 0; font-size: 14px; word-break: break-all; }
.fd-btn-danger { background: rgba(220, 53, 69, 0.2); border: 1px solid rgba(220, 53, 69, 0.5); color: inherit; padding: 8px 15px; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 14px; transition: 0.2s; }
.fd-btn-danger:hover { background: rgba(220, 53, 69, 0.5); }
.fd-btn-danger:disabled { opacity: 0.5; cursor: not-allowed; }

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

/* Toast Notification */
.fd-toast-container { position: fixed; bottom: 20px; right: 20px; z-index: 10000; display: flex; flex-direction: column; gap: 10px; }
.fd-toast { background: rgba(40,167,69,.9); color: white; padding: 12px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); font-weight: bold; font-size: 14px; opacity: 0; transform: translateY(20px); transition: opacity 0.3s ease, transform 0.3s ease; backdrop-filter: blur(4px); border: 1px solid rgba(255,255,255,.2); }
.fd-toast.fd-toast-show { opacity: 1; transform: translateY(0); }

/* Saved space badge */
.fd-saved-space-badge { display: inline-block; background: rgba(40,167,69,.2); border: 1px solid rgba(40,167,69,.5); color: inherit; padding: 5px 12px; border-radius: 20px; font-weight: bold; font-size: 14px; margin-left: 15px; vertical-align: middle; }
</style>
{/literal}

<div id="fd-main">

<div class="titrePage">
  <h2>Wyszukiwarka Duplikatów <span class="fd-saved-space-badge" id="fd-top-saved-space">Zaoszczędzone miejsce: {$FD_TOTAL_SAVED_SPACE}</span></h2>
</div>

<div class="fd-toast-container" id="fd-toast-container"></div>

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
        <div class="fd-group" data-phash="{$group.PHASH|escape:'html'}" data-title="{$group.TITLE|escape:'html'}" data-images="{$group.IMAGES|@json_encode|escape:'html'}">
          <h4>{$group.TITLE} <span style="font-size: 11px; opacity: 0.6; font-weight: normal;">(Hash: {$group.PHASH})</span> <button class="fd-btn" style="float: right; padding: 4px 10px; pointer-events: none;">Otwórz grupę</button></h4>
          <div style="display: flex; gap: 15px; flex-wrap: wrap; pointer-events: none; opacity: 0.8;">
            {foreach from=$group.IMAGES item=img}
              <div class="fd-img-wrap" data-id="{$img.ID}">
                <img src="{$img.PATH}" alt="{$img.NAME}">
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
      
      {for $p=$FD_START_PAGE to $FD_END_PAGE}
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

<!-- Modal -->
<div id="fd-modal">
  <div id="fd-modal-content">
    <span id="fd-modal-close">&times;</span>
    <h3 id="fd-modal-title" style="margin-top: 0; border-bottom: 1px solid rgba(128,128,128,.3); padding-bottom: 10px;">Grupa</h3>
    <div class="fd-modal-images" id="fd-modal-images">
      <!-- Images will be injected here via JS -->
    </div>
  </div>
</div>

<script type="text/javascript">
(function(){
  var modal = document.getElementById('fd-modal');
  var closeBtn = document.getElementById('fd-modal-close');
  var groups = document.querySelectorAll('.fd-group');

  // Format Bytes Helper for JS
  function formatBytes(bytes) {
    if (bytes >= 1048576) {
      return (bytes / 1048576).toFixed(2) + ' MB';
    } else if (bytes >= 1024) {
      return (bytes / 1024).toFixed(2) + ' KB';
    }
    return bytes + ' B';
  }

  // Toast Helper
  function showToast(message) {
    var container = document.getElementById('fd-toast-container');
    var toast = document.createElement('div');
    toast.className = 'fd-toast';
    toast.innerText = message;
    container.appendChild(toast);

    // Animate in
    requestAnimationFrame(function() {
      requestAnimationFrame(function() {
        toast.classList.add('fd-toast-show');
      });
    });

    // Remove after 4 seconds
    setTimeout(function() {
      toast.classList.remove('fd-toast-show');
      setTimeout(function() {
        if(toast.parentNode) toast.parentNode.removeChild(toast);
      }, 300);
    }, 4000);
  }

  // Otwieranie modala
  groups.forEach(function(groupEl) {
    groupEl.addEventListener('click', function() {
      var title = groupEl.getAttribute('data-title');
      var phash = groupEl.getAttribute('data-phash');
      var imagesJson = groupEl.getAttribute('data-images');

      if(imagesJson) {
        var images = JSON.parse(imagesJson);
        openModal(title, phash, images, groupEl);
      }
    });
  });

  // Zamykanie modala
  closeBtn.addEventListener('click', function() {
    closeModal();
  });
  window.addEventListener('click', function(e) {
    if (e.target == modal) {
      closeModal();
    }
  });

  function closeModal(onComplete) {
    modal.classList.remove('fd-modal-show');
    modal.classList.add('fd-modal-closing');
    setTimeout(function() {
      modal.style.display = 'none';
      modal.classList.remove('fd-modal-closing');
      if (typeof onComplete === 'function') onComplete();
    }, 300); // Wait for transition
  }

  function openModal(title, phash, images, groupEl) {
    document.getElementById('fd-modal-title').innerText = title + ' (Hash: ' + phash + ')';
    var container = document.getElementById('fd-modal-images');
    container.innerHTML = '';

    images.forEach(function(img) {
      var wrap = document.createElement('div');
      wrap.className = 'fd-modal-img-wrap';
      wrap.id = 'fd-modal-img-' + img.ID;

      var link = document.createElement('a');
      link.href = img.URL;
      link.target = '_blank';

      var image = document.createElement('img');
      image.src = img.PATH;
      image.alt = img.NAME;

      link.appendChild(image);
      wrap.appendChild(link);

      var info = document.createElement('div');
      info.className = 'fd-modal-img-info';

      var creationDate = img.DATE_CREATION ? img.DATE_CREATION : 'Nieznana';
      var fileSize = img.FILE_SIZE ? img.FILE_SIZE : 'Brak danych';
      var hasLocation = img.HAS_LOCATION ? img.HAS_LOCATION : 'Nie';
      var albumsCount = img.ALBUMS_COUNT ? img.ALBUMS_COUNT : 0;

      info.innerHTML = 'ID: ' + img.ID + '<br>' +
                       'Plik: ' + img.FILE + '<br>' +
                       'Data utworzenia: ' + creationDate + '<br>' +
                       'Rozmiar: ' + fileSize + '<br>' +
                       'Lokalizacja: ' + hasLocation + '<br>' +
                       'W albumach: ' + albumsCount + '<br><br>';

      var delBtn = document.createElement('button');
      delBtn.className = 'fd-btn-danger';
      delBtn.innerHTML = 'Usuń zdjęcie';
      delBtn.onclick = function() {
        if(confirm('Czy na pewno chcesz bezpowrotnie usunąć to zdjęcie (ID: ' + img.ID + ')?')) {
          deleteImage(img.ID, phash, wrap, groupEl);
        }
      };

      info.appendChild(delBtn);
      wrap.appendChild(info);
      container.appendChild(wrap);
    });

    // Reset classes and show
    modal.classList.remove('fd-modal-closing');
    modal.style.display = 'block';

    // Request animation frame to ensure transition plays
    requestAnimationFrame(function() {
      requestAnimationFrame(function() {
        modal.classList.add('fd-modal-show');
      });
    });
  }

  function deleteImage(imageId, groupPhash, wrapEl, groupEl) {
    var btn = wrapEl.querySelector('.fd-btn-danger');
    var originalText = btn.innerHTML;
    btn.innerHTML = 'Usuwanie...';
    btn.disabled = true;

    var url = actionUrl + '&action=delete_image&image_id=' + imageId + '&pwg_token=' + pwgToken;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.status === 'ok') {
          btn.innerHTML = 'Usunięto';

          // Format bytes for toast
          var deletedFormatted = formatBytes(data.deleted_bytes || 0);
          var totalFormatted = formatBytes(data.total_saved_bytes || 0);

          // Update top counter
          document.getElementById('fd-top-saved-space').innerText = 'Zaoszczędzone miejsce: ' + totalFormatted;

          // Show toast
          if ((data.deleted_bytes || 0) > 0) {
            showToast('Zaoszczędzono: ' + deletedFormatted + ' (Łącznie: ' + totalFormatted + ')');
          }

          // Trigger collapse animation
          wrapEl.classList.add('fd-collapsing');

          setTimeout(function() {
            // Remove DOM element completely after transition
            if (wrapEl.parentNode) {
              wrapEl.parentNode.removeChild(wrapEl);
            }

            // Update JSON data on the group DOM element so if we reopen modal, it's correct
            var imagesJson = groupEl.getAttribute('data-images');
            if (imagesJson) {
              var images = JSON.parse(imagesJson);
              var updatedImages = images.filter(function(img) { return img.ID != imageId; });
              groupEl.setAttribute('data-images', JSON.stringify(updatedImages));

              // Hide from the main list behind the modal
              var mainListImgWrap = groupEl.querySelector('.fd-img-wrap[data-id="' + imageId + '"]');
              if (mainListImgWrap) {
                mainListImgWrap.style.display = 'none';
              }

              // If only 1 image left, close modal then fade out group
              if (updatedImages.length <= 1) {
                closeModal(function() {
                  groupEl.classList.add('fd-fading-out');
                  setTimeout(function() {
                    groupEl.style.display = 'none';
                  }, 300);
                });
              }
            }
          }, 300); // Wait for collapsing to finish
        } else {
          alert('Błąd usuwania: ' + (data.error || 'Nieznany błąd'));
          btn.innerHTML = originalText;
          btn.disabled = false;
        }
      })
      .catch(error => {
        console.error('Error deleting image:', error);
        alert('Wystąpił błąd komunikacji z serwerem.');
        btn.innerHTML = originalText;
        btn.disabled = false;
      });
  }
})();
</script>
