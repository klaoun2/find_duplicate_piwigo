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
#fd-main .fd-btn,
.fd-btn,
.fd-favorite-all-btn,
.fd-sync-zoom-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 7px 14px;
  border-radius: 6px;
  font-family: inherit;
  font-size: 13px;
  font-weight: 600;
  line-height: 1.2;
  cursor: pointer;
  transition: all 0.2s ease;
  vertical-align: middle;
  box-sizing: border-box;
  text-transform: none;
  letter-spacing: normal;
}
#fd-main .fd-btn,
.fd-btn {
  border: 1px solid rgba(90,150,220,.6);
  background: rgba(90,150,220,.16);
  color: #66b8ff;
}
#fd-main .fd-btn:hover,
.fd-btn:hover,
#fd-main .fd-group:hover:not(:has(.fd-group-fav-btn:hover)) .fd-open-group-btn {
  background: rgba(90,150,220,.28);
  border-color: rgba(90,150,220,.85);
  box-shadow: 0 2px 8px rgba(90,150,220,.25);
  transform: translateY(-1px);
}
#fd-main .fd-btn:disabled,
.fd-btn:disabled,
.fd-favorite-all-btn:disabled,
.fd-sync-zoom-btn:disabled {
  background: rgba(128,128,128,.1);
  border-color: rgba(128,128,128,.2);
  cursor: not-allowed;
  opacity: 0.6;
  transform: none;
  box-shadow: none;
}
.fd-btn-sm {
  padding: 5px 12px !important;
  font-size: 12px !important;
  min-height: 28px;
}
.fd-group-size-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 5px 12px;
  min-height: 28px;
  background: rgba(255,255,255,0.08);
  border-radius: 6px;
  font-family: inherit;
  font-size: 12px;
  line-height: 1.2;
  font-weight: 600;
  color: #e8eaed;
  border: 1px solid rgba(255,255,255,0.3);
  box-sizing: border-box;
  position: relative;
  transition: all 0.2s ease;
}
.fd-group-size-badge:hover {
  background: rgba(255,255,255,0.15);
  border-color: rgba(255,255,255,0.5);
}
.fd-size-popover {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  min-width: 230px;
  max-width: 340px;
  background: rgba(28, 30, 34, 0.96);
  color: #eee;
  border: 1px solid rgba(128, 128, 128, 0.45);
  border-radius: 8px;
  padding: 8px 12px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(6px);
  z-index: 50;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-4px);
  transition: opacity 0.18s ease, transform 0.18s ease, visibility 0.18s ease;
  pointer-events: none;
  text-align: left;
  font-weight: normal;
  font-size: 11px;
  line-height: 1.4;
}
.fd-group-size-badge:hover .fd-size-popover {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}
.fd-size-popover-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding: 3px 0;
  border-bottom: 1px solid rgba(128, 128, 128, 0.18);
}
.fd-size-popover-row:last-child {
  border-bottom: none;
}
.fd-size-popover-name {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  opacity: 0.92;
}
.fd-size-popover-val {
  font-weight: 600;
  white-space: nowrap;
  color: #5da9e9;
}
#fd-main .fd-progress-container { margin-top: 15px; height: 15px; background: rgba(128,128,128,.15); border-radius: 8px; overflow: hidden; display: none; }
#fd-main .fd-progress-bar { height: 100%; background: rgba(90,160,90,.8); width: 0%; transition: width 1s linear; }
#fd-main .fd-group { border: 1px solid rgba(128,128,128,.3); margin-bottom: 20px; padding: 15px; border-radius: 10px; background: rgba(128,128,128,.04); }
#fd-main .fd-group h4 { margin-top: 0; color: inherit; }
#fd-main .fd-img-wrap { width: 150px; text-align: center; position: relative; }
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
#fd-modal-content { background: var(--theme-bg, #222); color: var(--theme-color, #eee); margin: 2% auto; padding: 30px; border-radius: 12px; width: 90%; max-width: 1200px; position: relative; border: 1px solid rgba(128,128,128,.4); box-shadow: 0 10px 40px rgba(0,0,0,0.7); opacity: 0; transform: translateY(-40px); transition: opacity 0.3s ease, transform 0.3s ease; }
#fd-modal.fd-modal-show #fd-modal-content { opacity: 1; transform: translateY(0); }
#fd-modal.fd-modal-closing { opacity: 0; }
#fd-modal.fd-modal-closing #fd-modal-content { opacity: 0; transform: translateY(-40px); }
#fd-modal-close { position: absolute; right: 20px; top: 15px; font-size: 28px; font-weight: bold; cursor: pointer; opacity: 0.7; }
#fd-modal-close:hover { opacity: 1; }
.fd-modal-images { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; justify-content: center; }
.fd-modal-img-wrap { text-align: center; background: rgba(128,128,128,.1); padding: 15px; border-radius: 8px; border: 1px solid rgba(128,128,128,.3); max-width: 45%; flex-grow: 1; transition: opacity 0.3s ease, transform 0.3s ease, max-width 0.3s ease, padding 0.3s ease, margin 0.3s ease, border-width 0.3s ease, flex-grow 0.3s ease; transform-origin: top center; overflow: hidden; }
.fd-modal-img-wrap.fd-collapsing { opacity: 0; transform: scale(0.8); max-width: 0; padding-left: 0; padding-right: 0; margin-left: 0; margin-right: 0; border-width: 0; flex-grow: 0.0001; }
.fd-modal-img-wrap a { display: inline-block; position: relative; overflow: hidden; line-height: 0; }
.fd-modal-img-wrap img { max-width: 100%; max-height: 80vh; object-fit: contain; border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.3); vertical-align: top; }
.fd-modal-img-wrap img.fd-zoom-active-cursor { cursor: crosshair; }

.fd-zoom-lens {
  position: absolute;
  width: 225px;
  height: 225px;
  border: 2px solid rgba(255, 255, 255, 0.8);
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
  background-repeat: no-repeat;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.2s ease;
  z-index: 20;
  transform: translate(-50%, -50%); /* Center the lens over the mouse */
}

.fd-modal-img-actions-overlay {
  position: absolute;
  bottom: 0; left: 0; width: 100%; height: 80px;
  background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.3s ease, transform 0.3s ease;
  border-bottom-left-radius: 4px;
  border-bottom-right-radius: 4px;
  z-index: 10;
  pointer-events: none;
}
.fd-modal-img-wrap a:hover .fd-modal-img-actions-overlay { opacity: 1; transform: translateY(0); pointer-events: auto; }

.fd-badge { display: inline-block; padding: 4px 8px; border-radius: 12px; background: rgba(128,128,128,0.15); margin: 2px; font-size: 11px; border: 1px solid rgba(128,128,128,0.2); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 95%; }
.fd-badge.badge-gps { color:#5cb85c; border-color: rgba(92, 184, 92, 0.4); background: rgba(92, 184, 92, 0.1); }
.fd-badge.badge-motion { color:#d9edf7; border-color: rgba(217, 237, 247, 0.4); background: rgba(217, 237, 247, 0.1); }
.fd-modal-img-info { margin: 2px 0; font-size: 14px; word-break: break-all; }
.fd-btn-danger { background: rgba(220, 53, 69, 0.2); border: 1px solid rgba(220, 53, 69, 0.5); color: inherit; border-radius: 12px; cursor: pointer; font-weight: bold; font-size: 24px; transition: all 0.2s ease; width: 50px; height: 50px; display: inline-flex; align-items: center; justify-content: center; padding: 0; line-height: 1; }
.fd-btn-danger:hover { background: rgba(220, 53, 69, 0.5); box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4); transform: translateY(-2px); }
.fd-btn-danger:disabled { opacity: 0.5; cursor: not-allowed; transform: none; box-shadow: none; }

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

/* Tabs & Toggle */
.fd-tabs { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 1px solid rgba(128,128,128,.3); padding-bottom: 10px; }
.fd-tab { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; cursor: pointer; border-radius: 6px; background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.22); font-size: 13px; font-weight: 600; color: #d0d4d9; transition: all 0.2s ease; }
.fd-tab.active { background: rgba(90,150,220,.22); border-color: rgba(90,150,220,.65); color: #66b8ff; }
.fd-tab:hover:not(.active) { background: rgba(255,255,255,.14); border-color: rgba(255,255,255,.38); color: #fff; transform: translateY(-1px); }

.fd-favorite-btn {
  background: rgba(255,193,7,0.1);
  border: 1px solid rgba(255,193,7,0.5);
  color: #ffc107;
  cursor: pointer;
  padding: 0;
  border-radius: 12px;
  font-size: 28px;
  transition: all 0.2s ease;
  width: 50px;
  height: 50px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  padding-bottom: 3px;
}
.fd-favorite-btn.active { background: rgba(255,193,7,0.3); font-weight: bold; text-shadow: 0 0 5px rgba(255,193,7,0.5); }
.fd-favorite-btn:hover { background: rgba(255,193,7,0.4); box-shadow: 0 4px 12px rgba(255,193,7,0.4); transform: translateY(-2px); }

.fd-favorite-all-btn {
  background: rgba(255,193,7,0.15);
  border: 1px solid rgba(255,193,7,0.6);
  color: #ffc107;
}
.fd-favorite-all-btn:hover {
  background: rgba(255,193,7,0.28);
  box-shadow: 0 2px 8px rgba(255,193,7,0.25);
  transform: translateY(-1px);
}

.fd-sync-zoom-btn {
  background: rgba(90,150,220,0.16);
  border: 1px solid rgba(90,150,220,0.6);
  color: #66b8ff;
}
.fd-sync-zoom-btn.active {
  background: rgba(90,150,220,0.6);
  color: #fff;
}
.fd-sync-zoom-btn:hover {
  background: rgba(90,150,220,0.28);
  box-shadow: 0 2px 8px rgba(90,150,220,0.2);
  transform: translateY(-1px);
}

/* Light theme high-contrast overrides */
#fd-main.fd-theme-light .fd-group-size-badge {
  color: #333333;
  background: rgba(0, 0, 0, 0.06);
  border-color: rgba(0, 0, 0, 0.28);
}
#fd-main.fd-theme-light .fd-group-size-badge:hover {
  background: rgba(0, 0, 0, 0.12);
  border-color: rgba(0, 0, 0, 0.45);
}
#fd-main.fd-theme-light .fd-favorite-all-btn,
#fd-modal.fd-theme-light .fd-favorite-all-btn {
  color: #946200;
  background: rgba(255, 193, 7, 0.22);
  border-color: rgba(200, 140, 0, 0.65);
}
#fd-main.fd-theme-light .fd-favorite-all-btn:hover,
#fd-modal.fd-theme-light .fd-favorite-all-btn:hover {
  background: rgba(255, 193, 7, 0.35);
  border-color: rgba(180, 120, 0, 0.85);
}
#fd-main.fd-theme-light .fd-btn,
#fd-main.fd-theme-light .fd-sync-zoom-btn,
#fd-modal.fd-theme-light .fd-sync-zoom-btn {
  color: #0d5aa7;
  background: rgba(90, 150, 220, 0.16);
  border-color: rgba(50, 120, 200, 0.55);
}
#fd-main.fd-theme-light .fd-btn:hover,
#fd-main.fd-theme-light .fd-sync-zoom-btn:hover,
#fd-modal.fd-theme-light .fd-sync-zoom-btn:hover,
#fd-main.fd-theme-light .fd-group:hover:not(:has(.fd-group-fav-btn:hover)) .fd-open-group-btn {
  background: rgba(90, 150, 220, 0.28);
  border-color: rgba(30, 100, 185, 0.8);
}
#fd-main.fd-theme-light .fd-sync-zoom-btn.active,
#fd-modal.fd-theme-light .fd-sync-zoom-btn.active {
  color: #fff;
  background: rgba(40, 115, 200, 0.85);
}
#fd-main.fd-theme-light .fd-tab {
  color: #444444;
  background: rgba(0, 0, 0, 0.05);
  border-color: rgba(0, 0, 0, 0.22);
}
#fd-main.fd-theme-light .fd-tab:hover:not(.active) {
  color: #111111;
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.38);
}
#fd-main.fd-theme-light .fd-tab.active {
  color: #0d5aa7;
  background: rgba(90, 150, 220, 0.2);
  border-color: rgba(50, 120, 200, 0.65);
}
#fd-modal.fd-theme-light {
  background-color: rgba(0, 0, 0, 0.55);
}
#fd-modal.fd-theme-light #fd-modal-content {
  background: #f8f9fa;
  color: #222222;
  border-color: rgba(0, 0, 0, 0.2);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25);
}
#fd-modal.fd-theme-light .fd-modal-img-wrap {
  background: rgba(0, 0, 0, 0.03);
  border-color: rgba(0, 0, 0, 0.15);
}
#fd-modal.fd-theme-light .fd-badge {
  background: rgba(0, 0, 0, 0.06);
  border-color: rgba(0, 0, 0, 0.18);
  color: #333333;
}
#fd-modal.fd-theme-light .fd-badge.badge-gps {
  color: #257925;
  background: rgba(45, 145, 45, 0.12);
  border-color: rgba(45, 145, 45, 0.4);
}
#fd-modal.fd-theme-light .fd-badge.badge-motion {
  color: #16647a;
  background: rgba(22, 100, 122, 0.12);
  border-color: rgba(22, 100, 122, 0.38);
}

.fd-zoom-toggle-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0,0,0,0.5);
  color: #fff;
  border: 1px solid rgba(255,255,255,0.4);
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  cursor: pointer;
  transition: all 0.2s ease;
  z-index: 15;
  backdrop-filter: blur(2px);
}
.fd-zoom-toggle-btn.active {
  background: rgba(90,150,220,0.8);
  border-color: rgba(255,255,255,0.8);
}
.fd-zoom-toggle-btn:hover {
  background: rgba(0,0,0,0.8);
  transform: scale(1.1);
}
.fd-zoom-toggle-btn.active:hover {
  background: rgba(90,150,220,1);
}

.fd-search-bar { display: flex; gap: 10px; margin-bottom: 20px; align-items: center; }
.fd-search-bar input { padding: 8px 12px; border-radius: 6px; border: 1px solid rgba(128,128,128,.4); background: rgba(128,128,128,.1); color: inherit; flex-grow: 1; max-width: 300px; }

/* Toast Notification */
.fd-toast-container { position: fixed; bottom: 16px; right: 16px; z-index: 10000; display: flex; flex-direction: column; gap: 6px; align-items: flex-end; }
.fd-toast { background: rgba(40,167,69,.9); color: white; padding: 8px 12px; border-radius: 6px; box-shadow: 0 3px 10px rgba(0,0,0,0.25); font-weight: 500; font-size: 12px; line-height: 1.35; max-width: 320px; opacity: 0; transform: translateY(15px); transition: opacity 0.3s ease, transform 0.3s ease; backdrop-filter: blur(4px); border: 1px solid rgba(255,255,255,.2); }
.fd-toast.fd-toast-fav { background: rgba(180,130,0,.92); border-color: rgba(255,193,7,.6); color: #fff; }
.fd-toast.fd-toast-show { opacity: 1; transform: translateY(0); }

/* Image Loader Spinner */
.fd-img-loader { width: 30px; height: 30px; border: 3px solid rgba(128,128,128,0.2); border-top-color: #fff; border-radius: 50%; animation: fd-spin 1s linear infinite; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 1; }
@keyframes fd-spin { to { transform: translate(-50%, -50%) rotate(360deg); } }
.fd-lazy-img-element { opacity: 0; transition: opacity 0.5s ease; position: relative; z-index: 2; }
.fd-lazy-img-element.loaded { opacity: 1; }

/* Saved space badge */
.fd-saved-space-badge { display: inline-block; background: rgba(40,167,69,.2); border: 1px solid rgba(40,167,69,.5); color: inherit; padding: 5px 12px; border-radius: 20px; font-weight: bold; font-size: 14px; margin-left: 15px; vertical-align: middle; }
</style>
{/literal}

<div id="fd-main">

<div class="titrePage">
  <h2>{'Find Duplicates'|translate} <span style="font-size: 14px; opacity: 0.6; font-weight: normal; margin-left: 10px;">v{$FD_VERSION|default:'1.0.0'}</span> <span class="fd-saved-space-badge" id="fd-top-saved-space">{'Saved space'|translate}: {$FD_TOTAL_SAVED_SPACE}</span></h2>
</div>

<div class="fd-toast-container" id="fd-toast-container"></div>

{if $FD_MODE == 'visual' && (($FD_HASHED_IMAGES + $FD_FAILED_IMAGES) < $FD_TOTAL_IMAGES || ($FD_FAILED_IMAGES > 0 && $FD_FAILED_PERCENT >= 5))}
<div class="fd-panel">
  <h3>{'Gallery scanning status'|translate}</h3>
  <p>{'To effectively find visual duplicates, the plugin must first generate a hash (fingerprint) for each photo in your gallery.'|translate}</p>

  <p>
    {'Scanned photos:'|translate} <strong id="fd-hashed">{$FD_HASHED_IMAGES}</strong> / <strong id="fd-total">{$FD_TOTAL_IMAGES}</strong>
  </p>

  <button id="fd-scan-btn" class="fd-btn" {if ($FD_HASHED_IMAGES + $FD_FAILED_IMAGES) >= $FD_TOTAL_IMAGES && $FD_TOTAL_IMAGES > 0}disabled{/if}>
    {'Scan gallery'|translate}
  </button>
  {if $FD_FAILED_IMAGES > 0 && $FD_FAILED_PERCENT >= 5}
  <button id="fd-retry-btn" class="fd-btn" style="background: rgba(220,53,69,0.2); border-color: rgba(220,53,69,0.5); color: #d9534f; margin-left: 10px;">
    {'Retry %s failed images'|translate|sprintf:$FD_FAILED_IMAGES}
  </button>
  {/if}

  <div class="fd-progress-container" id="fd-progress-container">
    <div class="fd-progress-bar" id="fd-progress-bar"></div>
  </div>
</div>
{/if}

<div class="fd-tabs" id="fd-tabs-container">
  <div class="fd-tab {if $FD_MODE == 'visual'}active{/if}" data-mode="visual">
    {'Visual (pHash)'|translate}
    <span style="font-size: 14px; opacity: 0.7; cursor: help; margin-left: 5px; border-bottom: 1px dotted;" title="{'Finds duplicates by analyzing the actual visual content of the photos (pixel similarity).'|translate}">?</span>
  </div>
  <div class="fd-tab {if $FD_MODE == 'time'}active{/if}" data-mode="time">
    {'Time (Rolling)'|translate}
    <span style="font-size: 14px; opacity: 0.7; cursor: help; margin-left: 5px; border-bottom: 1px dotted;" title="{'Finds photos taken at the exact same time, regardless of what they look like.'|translate}">?</span>
  </div>
</div>

<script type="text/javascript">
(function(){
  function applyFdTheme() {
    var isDark = true;
    var el = document.getElementById('fd-main') || document.body;
    while (el && el !== document) {
      var bg = window.getComputedStyle(el).backgroundColor;
      if (bg && bg !== 'transparent' && bg !== 'rgba(0, 0, 0, 0)') {
        var m = bg.match(/\d+(\.\d+)?/g);
        if (m && m.length >= 3) {
          var r = parseFloat(m[0]);
          var g = parseFloat(m[1]);
          var b = parseFloat(m[2]);
          var a = m.length >= 4 ? parseFloat(m[3]) : 1;
          if (a > 0.2) {
            var lum = 0.299 * r + 0.587 * g + 0.114 * b;
            isDark = lum < 140;
            break;
          }
        }
      }
      el = el.parentNode;
    }
    var addCls = isDark ? 'fd-theme-dark' : 'fd-theme-light';
    var remCls = isDark ? 'fd-theme-light' : 'fd-theme-dark';
    var mainEl = document.getElementById('fd-main');
    var modalEl = document.getElementById('fd-modal');
    if (mainEl) {
      mainEl.classList.remove(remCls);
      mainEl.classList.add(addCls);
    }
    if (modalEl) {
      modalEl.classList.remove(remCls);
      modalEl.classList.add(addCls);
    }
  }
  window.applyFdTheme = applyFdTheme;
  applyFdTheme();
  window.addEventListener('DOMContentLoaded', applyFdTheme);
  window.addEventListener('load', applyFdTheme);

  var tabs = document.querySelectorAll('.fd-tab');
  tabs.forEach(function(tab) {
      tab.addEventListener('click', function() {
          // Reset explicitly on tab switch
          var mode = this.getAttribute('data-mode');
          var sim = document.getElementById('fd-similarity-range') ? document.getElementById('fd-similarity-range').value : 100;
          var chk = document.getElementById('fd-same-album-chk');
          var sameAlbum = chk && chk.checked ? 1 : 0;
          // Do not carry over search and hidden states to avoid sticky confusion
          var actionUrl = "{$FD_ACTION_URL|escape:'javascript'}";
          window.location.href = actionUrl + '&fd_mode=' + mode + '&similarity=' + sim + '&same_album=' + sameAlbum;
      });
  });
})();
</script>

<script type="text/javascript">
var pwgToken = "{$PWG_TOKEN}";
var actionUrl = "{$FD_ACTION_URL}";
var isScanning = false;

var scanBtn = document.getElementById('fd-scan-btn');
if (scanBtn) {
  scanBtn.addEventListener('click', function() {
    if (isScanning) return;
    isScanning = true;
    this.disabled = true;
    this.innerText = '{'Scanning in progress...'|translate|escape:'javascript'}';
    document.getElementById('fd-progress-container').style.display = 'block';
    scanChunk();
  });
}

var retryBtn = document.getElementById('fd-retry-btn');
if (retryBtn) {
  retryBtn.addEventListener('click', function() {
    var btn = this;
    btn.disabled = true;
    btn.innerText = '{'Retrying...'|translate|escape:'javascript'}';

    fetch(actionUrl + '&action=retry_failed&pwg_token=' + pwgToken)
      .then(response => response.json())
      .then(data => {
        if (data.status === 'ok') {
          location.reload();
        }
      })
      .catch(error => {
        console.error('Error during retry:', error);
        alert('{'An error occurred.'|translate|escape:'javascript'}');
        btn.disabled = false;
      });
  });
}

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
        document.getElementById('fd-scan-btn').innerText = '{'Scanning completed'|translate|escape:'javascript'}';
        location.reload(); // Przeładuj, by pokazać duplikaty
      }
    })
    .catch(error => {
      console.error('Error during scan:', error);
      alert('{'An error occurred during scanning. Try refreshing the page.'|translate|escape:'javascript'}');
      isScanning = false;
      document.getElementById('fd-scan-btn').innerText = '{'Resume scanning'|translate|escape:'javascript'}';
      document.getElementById('fd-scan-btn').disabled = false;
    });
}
</script>

{if $FD_MODE == 'time' || (($FD_HASHED_IMAGES + $FD_FAILED_IMAGES) >= $FD_TOTAL_IMAGES && $FD_TOTAL_IMAGES > 0)}

<form id="fd-filter-form">
  <input type="hidden" id="fd-mode-input" value="{$FD_MODE}">

  <div class="fd-search-bar">
    <label for="fd-search-group">{'Filter by album/group name:'|translate}</label>
    <input type="text" id="fd-search-group" value="{$FD_SEARCH_GROUP|escape:'html'}" placeholder="{'e.g. Trip...'|translate}">
    <button type="submit" class="fd-btn">{'Search'|translate}</button>
  </div>

  <div class="fd-toolbar">
    <label id="fd-similarity-container" {if $FD_MODE == 'time'}style="display:none;"{/if}>
      {'Similarity:'|translate}
      <input type="range" id="fd-similarity-range" min="80" max="100" value="{$FD_SIMILARITY}" oninput="document.getElementById('fd-sim-val').innerText = this.value + '%'">
      <span id="fd-sim-val">{$FD_SIMILARITY}%</span>
    </label>

    <label id="fd-time-interval-container" {if $FD_MODE != 'time'}style="display:none;"{/if}>
      {'Time interval (seconds):'|translate}
      <select id="fd-time-interval-select" style="padding: 5px; border-radius: 4px; background: rgba(128,128,128,.1); color: inherit; border: 1px solid rgba(128,128,128,.4);">
        <option value="5" {if $FD_TIME_INTERVAL == 5}selected{/if}>5 s</option>
        <option value="10" {if $FD_TIME_INTERVAL == 10}selected{/if}>10 s</option>
        <option value="15" {if $FD_TIME_INTERVAL == 15}selected{/if}>15 s</option>
        <option value="30" {if $FD_TIME_INTERVAL == 30}selected{/if}>30 s</option>
        <option value="60" {if $FD_TIME_INTERVAL == 60}selected{/if}>60 s</option>
      </select>
    </label>

    <label>
      <input type="checkbox" id="fd-same-album-chk" value="1" {if $FD_SAME_ALBUM}checked{/if}>
      {'Search only in the same album'|translate}
    </label>

    <label style="margin-left: auto; color: #ffc107;">
      <input type="checkbox" id="fd-show-hidden-chk" value="1" {if $FD_SHOW_HIDDEN}checked{/if} style="display:none;">
      <span title="{'Show only hidden favorites (groups where all photos are marked as favorite)'|translate}" style="font-size: 20px; cursor: pointer; text-shadow: 1px 1px 2px rgba(0,0,0,0.3); opacity: {if $FD_SHOW_HIDDEN}1{else}0.5{/if};">★</span>
    </label>

    <label>
      {'Filter album:'|translate}
      <select id="fd-filter-album">
        <option value="0">{'-- All albums --'|translate}</option>
        {foreach from=$FD_CATEGORIES item=cat}
          <option value="{$cat.id}" {if $FD_FILTER_ALBUM == $cat.id}selected{/if}>
            {$cat.display_name|replace:'&amp;nbsp;':'&nbsp;'}
          </option>
        {/foreach}
      </select>
    </label>

    <button type="submit" class="fd-btn">{'Apply'|translate}</button>
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
      submitFilters();
    });
  }

  function submitFilters(overrideMode) {
      var mode = overrideMode || document.getElementById('fd-mode-input').value;
      var sim = document.getElementById('fd-similarity-range').value;
      var sameAlbum = chk.checked ? 1 : 0;
      var showHidden = document.getElementById('fd-show-hidden-chk').checked ? 1 : 0;
      var searchGroup = encodeURIComponent(document.getElementById('fd-search-group').value);
      var timeInterval = document.getElementById('fd-time-interval-select').value;

      var filterAlbum = document.getElementById("fd-filter-album") ? document.getElementById("fd-filter-album").value : 0;
      window.location.href = actionUrl + "&fd_mode=" + mode + "&similarity=" + sim + "&same_album=" + sameAlbum + "&fd_show_hidden=" + showHidden + "&fd_search_group=" + searchGroup + "&fd_time_interval=" + timeInterval + "&fd_filter_album=" + filterAlbum + "&pwg_token={$PWG_TOKEN}";
  }

  // Auto-submit when hidden checkbox is toggled
  // Auto-submit when filter album is changed
  var filterAlbumSel = document.getElementById('fd-filter-album');
  if (filterAlbumSel) {
      filterAlbumSel.addEventListener('change', function() {
          submitFilters();
      });
  }

  var hiddenChk = document.getElementById('fd-show-hidden-chk');
  if (hiddenChk) {
      hiddenChk.addEventListener('change', function() {
          submitFilters();
      });
  }

  function updateWarning() {
    if (!chk.checked) {
      var comparisons = (totalImages * (totalImages - 1)) / 2;
      var compStr = comparisons.toLocaleString();
      var warnTemplate = "{'Warning: Searching in the same album is disabled. Approximately %s comparisons will be made. This may take a while and load the server.'|translate|escape:'javascript'}";
      warnMsg.innerText = warnTemplate.replace('%s', compStr);
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
  <h3>{'Found duplicates'|translate}</h3>
  {if count($FD_DUPLICATES) > 0}
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
      <p style="margin: 0;">{'Found %s groups of related photos (total photos in groups: %s). Page %s of %s.'|translate|sprintf:"<strong>{$FD_TOTAL_GROUPS}</strong>":"<strong>{$FD_TOTAL_IMAGES_IN_GROUPS}</strong>":"{$FD_CURRENT_PAGE}":"{$FD_TOTAL_PAGES}"}</p>

      <div>
        <label for="fd-sort-select" style="margin-right: 5px;">{'Sort:'|translate}</label>
        <select id="fd-sort-select" style="padding: 5px; border-radius: 4px; border: 1px solid rgba(128,128,128,.4); background: rgba(128,128,128,.05); color: inherit;">
          <option value="default" {if $FD_SORT == 'default'}selected{/if}>{'Default'|translate}</option>
          <option value="size_desc" {if $FD_SORT == 'size_desc'}selected{/if}>{'Size descending'|translate}</option>
          <option value="size_asc" {if $FD_SORT == 'size_asc'}selected{/if}>{'Size ascending'|translate}</option>
          <option value="count_desc" {if $FD_SORT == 'count_desc'}selected{/if}>{'Photo count descending'|translate}</option>
          <option value="count_asc" {if $FD_SORT == 'count_asc'}selected{/if}>{'Photo count ascending'|translate}</option>
          <option value="date_desc" {if $FD_SORT == 'date_desc'}selected{/if}>{'From newest'|translate}</option>
          <option value="date_asc" {if $FD_SORT == 'date_asc'}selected{/if}>{'From oldest'|translate}</option>
          <option value="alpha_asc" {if $FD_SORT == 'alpha_asc'}selected{/if}>{'Alphabetically A-Z'|translate}</option>
          <option value="alpha_desc" {if $FD_SORT == 'alpha_desc'}selected{/if}>{'Alphabetically Z-A'|translate}</option>
        </select>
      </div>
    </div>

    <script type="text/javascript">
      document.getElementById('fd-sort-select').addEventListener('change', function() {
        var actionUrl = "{$FD_ACTION_URL|escape:'javascript'}";
        var mode = "{$FD_MODE|escape:'javascript'}";
        var similarity = "{$FD_SIMILARITY|escape:'javascript'}";
        var sameAlbum = "{$FD_SAME_ALBUM|escape:'javascript'}";
        var showHidden = "{$FD_SHOW_HIDDEN|escape:'javascript'}";
        var searchGroup = "{$FD_SEARCH_GROUP|escape:'url'}";
        var timeInterval = "{$FD_TIME_INTERVAL|escape:'javascript'}";
        var sortVal = this.value;

        var filterAlbum = document.getElementById("fd-filter-album") ? document.getElementById("fd-filter-album").value : 0;
        window.location.href = actionUrl + "&fd_mode=" + mode + "&similarity=" + similarity + "&same_album=" + sameAlbum + "&fd_show_hidden=" + showHidden + "&fd_search_group=" + searchGroup + "&fd_time_interval=" + timeInterval + "&fd_filter_album=" + filterAlbum + "&sort=" + sortVal + "&pwg_token={$PWG_TOKEN}";
      });
    </script>

    <div class="fd-duplicates-list">
      {foreach from=$FD_DUPLICATES item=group}
        <div class="fd-group" data-phash="{$group.PHASH|escape:'html'}" data-title="{$group.TITLE|escape:'html'}" data-images="{$group.IMAGES|@json_encode|escape:'html'}">
          <h4 style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px; margin-bottom: 10px;">
            <span>
              {$group.TITLE|escape:'html'} <span style="font-size: 11px; opacity: 0.6; font-weight: normal;">({if $FD_MODE == 'time'}{'Time range'|translate}{else}{'Hash:'|translate} {$group.PHASH|escape:'html'}{/if})</span>
            </span>
            <span style="display: inline-flex; align-items: center; gap: 8px; flex-wrap: wrap;">
              <span class="fd-group-size-badge">
                <span class="fd-group-size-text">{'Size:'|translate} {if $group.TOTAL_SIZE}{$group.TOTAL_SIZE|escape:'html'}{else}{'No data'|translate}{/if}</span>
                <span class="fd-size-popover">
                  {foreach from=$group.IMAGES item=img}
                    <span class="fd-size-popover-row" data-id="{$img.ID}">
                      <span class="fd-size-popover-name">📄 {$img.FILE|escape:'html'}</span>
                      <span class="fd-size-popover-val">{if $img.FILE_SIZE}{$img.FILE_SIZE|escape:'html'}{else}{'No data'|translate}{/if}</span>
                    </span>
                  {/foreach}
                </span>
              </span>
              <button type="button" class="fd-favorite-all-btn fd-btn-sm fd-group-fav-btn" data-target-status="{if $FD_SHOW_HIDDEN}0{else}1{/if}" title="{if $FD_SHOW_HIDDEN}{'Unmark all photos in this group from favorites. The group will return to the main duplicates list.'|translate}{else}{'Mark all photos in this group as favorites. When all photos are favorites, the group will be hidden from the duplicates list (accessible via the ★ filter).'|translate}{/if}">{if $FD_SHOW_HIDDEN}{'☆ Unmark all (restore group)'|translate}{else}{'★ Mark all (hide group)'|translate}{/if}</button>
              <button type="button" class="fd-btn fd-btn-sm fd-open-group-btn">{'Open group'|translate}</button>
            </span>
          </h4>
          <div style="display: flex; gap: 15px; flex-wrap: wrap; pointer-events: none; opacity: 0.8; clear: both; padding-top: 10px;">
            {foreach from=$group.IMAGES item=img}
              <div class="fd-img-wrap" data-id="{$img.ID}">
                <div class="fd-img-loader"></div>
                <img src="{$img.FULL_URL}" class="fd-lazy-img-element" onload="this.classList.add('loaded'); this.previousElementSibling.style.display='none';" alt="{$img.NAME|escape:'html'}">
                <div style="position: absolute; bottom: 5px; right: 5px; display: flex; gap: 3px; z-index: 3;">
                  {if $img.ALBUM_COUNT|default:0 > 1}
                    <span style="background: rgba(0,0,0,0.6); color: white; padding: 2px 5px; border-radius: 4px; font-size: 10px;" title="{'Belongs to multiple albums'|translate}">📁 {$img.ALBUM_COUNT}</span>
                  {/if}
                  {if $img.HAS_GPS|default:0}
                    <span style="background: rgba(0,0,0,0.6); color: white; padding: 2px 5px; border-radius: 4px; font-size: 10px;" title="{'Has GPS location'|translate}">📍</span>
                  {/if}
                  {if $img.HAS_MOTION|default:0}
                    <span style="background: rgba(0,0,0,0.6); color: white; padding: 2px 5px; border-radius: 4px; font-size: 10px;" title="{'Registered as Motion Picture'|translate}">🎬</span>
                  {/if}
                </div>
                {if $img.IS_FAVORITE}
                <div class="fd-thumb-fav-star" style="color: #ffc107; font-size: 24px; position: absolute; top: -5px; left: 5px; text-shadow: 1px 1px 3px rgba(0,0,0,0.8);">★</div>
                {/if}
              </div>
            {/foreach}
          </div>
        </div>
      {/foreach}
    </div>

    {if $FD_TOTAL_PAGES > 1}
    <div class="fd-pagination">
      {if $FD_CURRENT_PAGE > 1}
        <a href="{$FD_ACTION_URL}&fd_mode={$FD_MODE}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&fd_show_hidden={$FD_SHOW_HIDDEN}&fd_search_group={$FD_SEARCH_GROUP|escape:'url'}&fd_time_interval={$FD_TIME_INTERVAL}&fd_filter_album={$FD_FILTER_ALBUM}&sort={$FD_SORT}&p={$FD_CURRENT_PAGE-1}">{'Previous'|translate}</a>
      {/if}

      {for $p=$FD_START_PAGE to $FD_END_PAGE}
        {if $p == $FD_CURRENT_PAGE}
          <span class="fd-current">{$p}</span>
        {else}
          <a href="{$FD_ACTION_URL}&fd_mode={$FD_MODE}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&fd_show_hidden={$FD_SHOW_HIDDEN}&fd_search_group={$FD_SEARCH_GROUP|escape:'url'}&fd_time_interval={$FD_TIME_INTERVAL}&fd_filter_album={$FD_FILTER_ALBUM}&sort={$FD_SORT}&p={$p}">{$p}</a>
        {/if}
      {/for}

      {if $FD_CURRENT_PAGE < $FD_TOTAL_PAGES}
        <a href="{$FD_ACTION_URL}&fd_mode={$FD_MODE}&similarity={$FD_SIMILARITY}&same_album={$FD_SAME_ALBUM}&fd_show_hidden={$FD_SHOW_HIDDEN}&fd_search_group={$FD_SEARCH_GROUP|escape:'url'}&fd_time_interval={$FD_TIME_INTERVAL}&fd_filter_album={$FD_FILTER_ALBUM}&sort={$FD_SORT}&p={$FD_CURRENT_PAGE+1}">{'Next'|translate}</a>
      {/if}
    </div>
    {/if}

  {else}
    <p>{'No duplicates found.'|translate}</p>
  {/if}
</div>
{/if}

</div> <!-- /#fd-main -->

<!-- Modal -->
<div id="fd-modal">
  <div id="fd-modal-content">
    <span id="fd-modal-close">&times;</span>
    <h3 id="fd-modal-title" style="margin-top: 0; border-bottom: 1px solid rgba(128,128,128,.3); padding-bottom: 12px; padding-right: 35px; display: flex; align-items: center; flex-wrap: wrap; gap: 10px;">{'Group'|translate}</h3>
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
  var isSyncZoomActive = false;

  // HTML Escape Helper to prevent XSS
  function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

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
  function showToast(message, variant) {
    var container = document.getElementById('fd-toast-container');
    var toast = document.createElement('div');
    toast.className = 'fd-toast' + (variant === 'fav' ? ' fd-toast-fav' : '');
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

  function getFavoriteBtnTitle(isFav) {
    return isFav
      ? "{'Remove photo from favorites'|translate|escape:'javascript'}"
      : "{'Add photo to favorites (marking all photos in the group will hide the group)'|translate|escape:'javascript'}";
  }

  function closeModal(onComplete) {
    if (!modal.classList.contains('fd-modal-show')) {
      if (typeof onComplete === 'function') onComplete();
      return;
    }
    modal.classList.remove('fd-modal-show');
    modal.classList.add('fd-modal-closing');
    setTimeout(function() {
      modal.style.display = 'none';
      modal.classList.remove('fd-modal-closing');
      if (typeof onComplete === 'function') onComplete();
    }, 300); // Wait for transition
  }

  function fadeOutGroupAndCloseModal(groupEl) {
    closeModal();
    groupEl.classList.add('fd-fading-out');
    setTimeout(function() {
      groupEl.style.display = 'none';
    }, 300);
  }

  function checkGroupStatusAndClose(images, groupEl) {
    var showHiddenChk = document.getElementById('fd-show-hidden-chk');
    var showHidden = showHiddenChk ? showHiddenChk.checked : false;

    var allFavorites = true;
    for (var i = 0; i < images.length; i++) {
        if (images[i].IS_FAVORITE != 1) {
            allFavorites = false;
            break;
        }
    }

    var shouldFadeOut = showHidden ? !allFavorites : allFavorites;

    if (shouldFadeOut) {
      if (showHidden) {
        showToast("{'Group removed from hidden favorites and restored to the main duplicates list.'|translate|escape:'javascript'}", 'fav');
      } else {
        showToast("{'All photos in the group are marked as favorites — the group has been hidden (available under the ★ filter).'|translate|escape:'javascript'}", 'fav');
      }
      // Use setTimeout to allow the button to visually update before closing
      setTimeout(function() {
        fadeOutGroupAndCloseModal(groupEl);
      }, 150);
    }

    return shouldFadeOut;
  }

  function updateGroupThumbnailStar(groupEl, imageId, isFav) {
    var wrap = groupEl.querySelector('.fd-img-wrap[data-id="' + imageId + '"]');
    if (!wrap) return;
    var existingStar = wrap.querySelector('.fd-thumb-fav-star');
    if (isFav) {
      if (!existingStar) {
        var starDiv = document.createElement('div');
        starDiv.className = 'fd-thumb-fav-star';
        starDiv.style.cssText = 'color: #ffc107; font-size: 24px; position: absolute; top: -5px; left: 5px; text-shadow: 1px 1px 3px rgba(0,0,0,0.8);';
        starDiv.innerText = '★';
        wrap.appendChild(starDiv);
      }
    } else if (existingStar && existingStar.parentNode) {
      existingStar.parentNode.removeChild(existingStar);
    }
  }

  function setGroupFavorite(groupEl, targetStatus, btnEl, onSuccess) {
    var imagesJson = groupEl.getAttribute('data-images');
    if (!imagesJson) return;
    var images = JSON.parse(imagesJson);
    if (!images || !images.length) return;

    var ids = images.map(function(img) { return img.ID; }).join(',');
    var originalText = btnEl.innerHTML;
    btnEl.innerHTML = '...';
    btnEl.disabled = true;

    var url = actionUrl + '&action=set_group_favorite&image_ids=' + encodeURIComponent(ids) + '&is_favorite=' + encodeURIComponent(targetStatus) + '&pwg_token=' + pwgToken;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.status === 'ok') {
          var newFav = data.is_favorite == 1 ? 1 : 0;
          var updatedImages = images.map(function(img) {
            img.IS_FAVORITE = newFav;
            updateGroupThumbnailStar(groupEl, img.ID, newFav === 1);
            return img;
          });
          groupEl.setAttribute('data-images', JSON.stringify(updatedImages));

          if (typeof onSuccess === 'function') {
            onSuccess(updatedImages, newFav);
          }

          btnEl.innerHTML = originalText;
          btnEl.disabled = false;
          checkGroupStatusAndClose(updatedImages, groupEl);
        } else {
          var errorLabel = "{'Error:'|translate|escape:'javascript'}";
          var unknownErrorLabel = "{'Unknown error'|translate|escape:'javascript'}";
          alert(errorLabel + ' ' + (data.error || unknownErrorLabel));
          btnEl.innerHTML = originalText;
          btnEl.disabled = false;
        }
      })
      .catch(error => {
        console.error('Error setting group favorite:', error);
        alert("{'Communication error with the server.'|translate|escape:'javascript'}");
        btnEl.innerHTML = originalText;
        btnEl.disabled = false;
      });
  }

  // Otwieranie modala oraz obsługa przycisku ulubionych na karcie grupy
  groups.forEach(function(groupEl) {
    var groupFavBtn = groupEl.querySelector('.fd-group-fav-btn');
    if (groupFavBtn) {
      groupFavBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        var targetStatus = parseInt(groupFavBtn.getAttribute('data-target-status'), 10);
        if (isNaN(targetStatus)) targetStatus = 1;
        setGroupFavorite(groupEl, targetStatus, groupFavBtn);
      });
    }

    groupEl.addEventListener('click', function(e) {
      if (e.target.closest('.fd-group-fav-btn')) return;
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

  document.addEventListener('keydown', function(e) {
    if (modal.classList.contains('fd-modal-show')) {
      if (e.key === 'Escape') {
        closeModal();
      } else if (e.key === 'Delete') {
        var hoveredWrap = document.querySelector('.fd-modal-img-wrap:hover');
        if (hoveredWrap) {
          var delBtn = hoveredWrap.querySelector('.fd-btn-danger');
          if (delBtn && !delBtn.disabled) {
            delBtn.click();
          }
        }
      }
    }
  });

  if (typeof window.applyFdTheme === 'function') {
    window.applyFdTheme();
  }

  function openModal(title, phash, images, groupEl) {
    if (typeof window.applyFdTheme === 'function') {
      window.applyFdTheme();
    }
    isSyncZoomActive = false; // Reset on modal open

    var titleEl = document.getElementById('fd-modal-title');
    titleEl.innerHTML = ''; // wyczyszczenie

    var titleSpan = document.createElement('span');
    titleSpan.textContent = title;
    titleSpan.style.marginRight = '5px';
    titleEl.appendChild(titleSpan);

    var showHiddenChk = document.getElementById('fd-show-hidden-chk');
    var showHidden = showHiddenChk ? showHiddenChk.checked : false;
    var modalTargetStatus = showHidden ? 0 : 1;

    var favAllBtn = document.createElement('button');
    favAllBtn.type = 'button';
    favAllBtn.className = 'fd-favorite-all-btn';
    favAllBtn.innerHTML = showHidden ? "{'☆ Unmark all (restore group)'|translate|escape:'javascript'}" : "{'★ Mark all (hide group)'|translate|escape:'javascript'}";
    favAllBtn.title = showHidden
      ? "{'Unmark all photos in this group from favorites. The group will return to the main duplicates list.'|translate|escape:'javascript'}"
      : "{'Mark all photos in this group as favorites. When all photos are favorites, the group will be hidden from the duplicates list (accessible via the ★ filter).'|translate|escape:'javascript'}";
    favAllBtn.onclick = function() {
      setGroupFavorite(groupEl, modalTargetStatus, favAllBtn, function(updatedImages, newFav) {
        var buttons = document.getElementById('fd-modal-images').querySelectorAll('.fd-favorite-btn');
        buttons.forEach(function(btn) {
          btn.className = 'fd-favorite-btn ' + (newFav ? 'active' : '');
          btn.innerHTML = newFav ? '★' : '☆';
          btn.title = getFavoriteBtnTitle(newFav === 1);
        });
        images.forEach(function(img) {
          img.IS_FAVORITE = newFav;
        });
      });
    };
    titleEl.appendChild(favAllBtn);

    var syncZoomBtn = document.createElement('button');
    syncZoomBtn.type = 'button';
    syncZoomBtn.className = 'fd-sync-zoom-btn';
    syncZoomBtn.innerHTML = '🔍🔍';
    syncZoomBtn.title = "{'Toggle synchronized magnifier'|translate|escape:'javascript'}";
    syncZoomBtn.onclick = function() {
      isSyncZoomActive = !isSyncZoomActive;
      if (isSyncZoomActive) {
        syncZoomBtn.classList.add('active');
        // Disable individual active zooms to avoid confusion
        document.querySelectorAll('.fd-zoom-toggle-btn.active').forEach(function(b) { b.classList.remove('active'); });
        document.querySelectorAll('#fd-modal-images img').forEach(function(img) { img.classList.add('fd-zoom-active-cursor'); });
      } else {
        syncZoomBtn.classList.remove('active');
        // Hide all lenses immediately when turned off
        document.querySelectorAll('#fd-modal-images .fd-zoom-lens').forEach(function(l) { l.style.opacity = '0'; });
        document.querySelectorAll('#fd-modal-images img').forEach(function(img) { img.classList.remove('fd-zoom-active-cursor'); });
      }
    };
    titleEl.appendChild(syncZoomBtn);

    var container = document.getElementById('fd-modal-images');
    container.innerHTML = '';

    images.forEach(function(img) {
      var wrap = document.createElement('div');
      wrap.className = 'fd-modal-img-wrap';
      wrap.id = 'fd-modal-img-' + img.ID;

      var link = document.createElement('a');
      link.href = img.URL;
      link.target = '_blank';
      link.style.position = 'relative';
      link.style.display = 'block';
      link.style.minHeight = '150px';

      var loader = document.createElement('div');
      loader.className = 'fd-img-loader';

      var image = document.createElement('img');
      image.src = img.FULL_URL;
      image.className = 'fd-lazy-img-element';
      image.onload = function() {
          this.classList.add('loaded');
          loader.style.display = 'none';
      };
      image.alt = img.NAME;

      var lens = document.createElement('div');
      lens.className = 'fd-zoom-lens';
      lens.style.backgroundImage = "url('" + img.FULL_URL + "')";
      lens.style.backgroundSize = "500%"; // 5x zoom for detailed inspection

      var zoomToggle = document.createElement('div');
      zoomToggle.className = 'fd-zoom-toggle-btn';
      zoomToggle.innerHTML = '🔍';
      zoomToggle.title = "{'Toggle zoom for this photo'|translate|escape:'javascript'}";
      zoomToggle.onclick = function(e) {
          e.preventDefault();
          e.stopPropagation();
          var isActive = zoomToggle.classList.contains('active');
          if (isActive) {
              zoomToggle.classList.remove('active');
              image.classList.remove('fd-zoom-active-cursor');
              lens.style.opacity = '0';
          } else {
              // Turn off global sync zoom to avoid conflict
              if (isSyncZoomActive) {
                  var syncBtn = document.querySelector('.fd-sync-zoom-btn');
                  if(syncBtn) syncBtn.click();
              }
              zoomToggle.classList.add('active');
              image.classList.add('fd-zoom-active-cursor');
          }
      };

      var overlay = document.createElement('div');
      overlay.className = 'fd-modal-img-actions-overlay';

      var favBtn = document.createElement('button');
      var isFav = img.IS_FAVORITE == 1;
      favBtn.className = 'fd-favorite-btn ' + (isFav ? 'active' : '');
      favBtn.innerHTML = isFav ? '★' : '☆';
      favBtn.title = getFavoriteBtnTitle(isFav);
      favBtn.style.margin = '0';
      // Prevent link click when clicking button
      favBtn.onclick = function(e) {
          e.preventDefault();
          e.stopPropagation();
          toggleFavorite(img.ID, favBtn, img, groupEl);
      };

      var delBtn = document.createElement('button');
      delBtn.className = 'fd-btn-danger';
      delBtn.innerHTML = '🗑️';
      delBtn.title = "{'Delete photo'|translate|escape:'javascript'}";
      delBtn.style.margin = '0';
      // Prevent link click when clicking button
      delBtn.onclick = function(e) {
        e.preventDefault();
        e.stopPropagation();
        var confirmMsg = "{'Are you sure you want to permanently delete this photo (ID: %s)?'|translate|escape:'javascript'}";
        if(confirm(confirmMsg.replace('%s', img.ID))) {
          deleteImage(img.ID, phash, wrap, groupEl);
        }
      };

      overlay.appendChild(favBtn);
      overlay.appendChild(delBtn);

      link.appendChild(loader);
      link.appendChild(image);
      link.appendChild(lens);
      link.appendChild(zoomToggle);
      link.appendChild(overlay);
      wrap.appendChild(link);

      var info = document.createElement('div');
      info.className = 'fd-modal-img-info';
      info.style.textAlign = 'center';
      info.style.marginTop = '10px';
      info.style.display = 'flex';
      info.style.flexWrap = 'wrap';
      info.style.justifyContent = 'center';
      info.style.gap = '5px';

      var badgesHtml = '';

      var creationDate = img.DATE_CREATION ? img.DATE_CREATION : "{'Unknown'|translate|escape:'javascript'}";
      badgesHtml += '<span class="fd-badge" title="{'Creation date'|translate|escape:'javascript'}">📅 ' + escapeHtml(creationDate) + '</span>';

      var fileSize = img.FILE_SIZE ? img.FILE_SIZE : "{'No data'|translate|escape:'javascript'}";
      badgesHtml += '<span class="fd-badge" title="{'File size'|translate|escape:'javascript'}">💾 ' + escapeHtml(fileSize) + '</span>';

      if (img.HAS_GPS == 1) {
          badgesHtml += '<span class="fd-badge badge-gps" title="{'Has GPS location'|translate|escape:'javascript'}">📍 GPS</span>';
      }
      if (img.HAS_MOTION == 1) {
          badgesHtml += '<span class="fd-badge badge-motion" title="{'Registered as Motion Picture'|translate|escape:'javascript'}">🎬 Motion</span>';
      }

      if (img.ALBUMS) {
         var albumCount = Object.keys(img.ALBUMS).length;
         var albumNames = [];
         for (var cat_id in img.ALBUMS) {
            albumNames.push(img.ALBUMS[cat_id]);
         }
         badgesHtml += '<span class="fd-badge" title="{'Albums:'|translate|escape:'javascript'} ' + escapeHtml(albumNames.join(', ')) + '">📁 ' + parseInt(albumCount, 10) + ' {'Album(s)'|translate|escape:'javascript'}</span>';
      }

      badgesHtml += '<span class="fd-badge" title="{'Photo ID'|translate|escape:'javascript'}">#️⃣ ' + parseInt(img.ID, 10) + '</span>';
      badgesHtml += '<span class="fd-badge" title="{'File name'|translate|escape:'javascript'}">📄 ' + escapeHtml(img.FILE) + '</span>';

      info.innerHTML = badgesHtml;

      wrap.appendChild(info);
      container.appendChild(wrap);

      // Mouse events for zoom
      link.addEventListener('mouseenter', function() {
        setZoomLensOpacity(lens, zoomToggle, true);
      });

      link.addEventListener('mouseleave', function() {
        setZoomLensOpacity(lens, zoomToggle, false);
      });

      link.addEventListener('mousemove', function(e) {
        var rect = image.getBoundingClientRect();

        var x = e.clientX - rect.left;
        var y = e.clientY - rect.top;

        // Hide lens when hovering near bottom action bar or the zoom button itself (Safety buffer)
        var bottomActionHeight = 80; // Approximate height of .fd-modal-img-actions-overlay
        var safetyMarginBottom = 40; // Pixels above the action bar to start hiding
        var safetyMarginTopRight = 30; // Pixels around the zoom button

        var hideLens = false;

        // 1. Bottom area check (Overlay + Buffer)
        if (y > (rect.height - bottomActionHeight - safetyMarginBottom)) {
            hideLens = true;
        }

        // 2. Top right area check (Zoom Toggle button + Buffer)
        // Zoom button is approx 36x36 at top:10px right:10px.
        // We define a block from x > (width - 10 - 36 - buffer) and y < (10 + 36 + buffer)
        if (x > (rect.width - 46 - safetyMarginTopRight) && y < (46 + safetyMarginTopRight)) {
            hideLens = true;
        }

        // Also fallback to direct target check just in case
        if (hideLens || e.target.closest('.fd-modal-img-actions-overlay') || e.target.closest('.fd-zoom-toggle-btn')) {
            setZoomLensOpacity(lens, zoomToggle, false);
            return;
        }

        // Show lens if we moved off the action zones but zoom is active
        setZoomLensOpacity(lens, zoomToggle, true);

        if (!isSyncZoomActive && !zoomToggle.classList.contains('active')) return;

        x = Math.max(0, Math.min(x, rect.width));
        y = Math.max(0, Math.min(y, rect.height));

        var percX = x / rect.width;
        var percY = y / rect.height;

        if (isSyncZoomActive) {
            var allWrappers = document.querySelectorAll('#fd-modal-images .fd-modal-img-wrap a');
            allWrappers.forEach(function(wrapper) {
                var currImage = wrapper.querySelector('img');
                var currLens = wrapper.querySelector('.fd-zoom-lens');

                if (currImage && currLens) {
                    var cRect = currImage.getBoundingClientRect();
                    var cX = percX * cRect.width;
                    var cY = percY * cRect.height;

                    currLens.style.left = cX + 'px';
                    currLens.style.top = cY + 'px';
                    currLens.style.backgroundPosition = (percX * 100) + '% ' + (percY * 100) + '%';
                }
            });
        } else {
             var cX = percX * rect.width;
             var cY = percY * rect.height;
             lens.style.left = cX + 'px';
             lens.style.top = cY + 'px';
             lens.style.backgroundPosition = (percX * 100) + '% ' + (percY * 100) + '%';
        }
      });
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

  function toggleFavorite(imageId, btnEl, imgObj, groupEl) {
    var originalText = btnEl.innerHTML;
    btnEl.innerHTML = '...';
    btnEl.disabled = true;

    var url = actionUrl + '&action=toggle_favorite&image_id=' + imageId + '&pwg_token=' + pwgToken;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.status === 'ok') {
          var isFav = data.is_favorite == 1;
          imgObj.IS_FAVORITE = data.is_favorite;

          btnEl.className = 'fd-favorite-btn ' + (isFav ? 'active' : '');
          btnEl.innerHTML = isFav ? '★' : '☆';
          btnEl.title = getFavoriteBtnTitle(isFav);
          updateGroupThumbnailStar(groupEl, imageId, isFav);

          // Update JSON data on the group DOM element
          var imagesJson = groupEl.getAttribute('data-images');
          if (imagesJson) {
            var images = JSON.parse(imagesJson);
            var updatedImages = images.map(function(img) {
                if (img.ID == imageId) {
                    img.IS_FAVORITE = data.is_favorite;
                }
                return img;
            });
            groupEl.setAttribute('data-images', JSON.stringify(updatedImages));

            var groupFadedOut = checkGroupStatusAndClose(updatedImages, groupEl);
            if (!groupFadedOut) {
              if (isFav) {
                var favCount = updatedImages.filter(function(item) { return item.IS_FAVORITE == 1; }).length;
                var addedMsg = "{'Photo added to favorites (%s/%s). Mark all photos in the group to hide it.'|translate|escape:'javascript'}";
                showToast(addedMsg.replace('%s', favCount).replace('%s', updatedImages.length), 'fav');
              } else {
                showToast("{'Photo removed from favorites.'|translate|escape:'javascript'}", 'fav');
              }
            }
          }
        } else {
          var errorLabel = "{'Error:'|translate|escape:'javascript'}";
          var unknownErrorLabel = "{'Unknown error'|translate|escape:'javascript'}";
          alert(errorLabel + ' ' + (data.error || unknownErrorLabel));
          btnEl.innerHTML = originalText;
        }
        btnEl.disabled = false;
      })
      .catch(error => {
        console.error('Error toggling favorite:', error);
        alert("{'Communication error with the server.'|translate|escape:'javascript'}");
        btnEl.innerHTML = originalText;
        btnEl.disabled = false;
      });
  }

  function deleteImage(imageId, groupPhash, wrapEl, groupEl) {
    var btn = wrapEl.querySelector('.fd-btn-danger');
    var originalText = btn.innerHTML;
    btn.innerHTML = '⏳';
    btn.disabled = true;

    var url = actionUrl + '&action=delete_image&image_id=' + imageId + '&pwg_token=' + pwgToken;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        if (data.status === 'ok') {
          btn.innerHTML = '✔️';

          // Format bytes for toast
          var deletedFormatted = formatBytes(data.deleted_bytes || 0);
          var totalFormatted = formatBytes(data.total_saved_bytes || 0);

          // Update top counter
          var savedSpaceLabel = "{'Saved space'|translate|escape:'javascript'}";
          document.getElementById('fd-top-saved-space').innerText = savedSpaceLabel + ': ' + totalFormatted;

          // Show toast
          if ((data.deleted_bytes || 0) > 0) {
            var savedLabel = "{'Saved: %s (Total: %s)'|translate|escape:'javascript'}";
            showToast(savedLabel.replace('%s', deletedFormatted).replace('%s', totalFormatted));
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

              // Update size popover and total size badge on the group card
              var popoverRow = groupEl.querySelector('.fd-size-popover-row[data-id="' + imageId + '"]');
              if (popoverRow && popoverRow.parentNode) {
                popoverRow.parentNode.removeChild(popoverRow);
              }
              var sizeTextEl = groupEl.querySelector('.fd-group-size-text');
              if (sizeTextEl) {
                var newTotalBytes = updatedImages.reduce(function(sum, item) { return sum + (parseInt(item.FILE_SIZE_BYTES, 10) || 0); }, 0);
                sizeTextEl.innerText = "{'Size:'|translate|escape:'javascript'} " + formatBytes(newTotalBytes);
              }

              // If only 1 image left, close modal then fade out group
              if (updatedImages.length <= 1) {
                fadeOutGroupAndCloseModal(groupEl);
              } else {
                // Check if the remaining images satisfy the "all favorites" condition
                checkGroupStatusAndClose(updatedImages, groupEl);
              }
            }
          }, 300); // Wait for collapsing to finish
        } else {
          var errorLabel = "{'Deletion error:'|translate|escape:'javascript'}";
          var unknownErrorLabel = "{'Unknown error'|translate|escape:'javascript'}";
          alert(errorLabel + ' ' + (data.error || unknownErrorLabel));
          btn.innerHTML = originalText;
          btn.disabled = false;
        }
      })
      .catch(error => {
        console.error('Error deleting image:', error);
        alert("{'Communication error with the server.'|translate|escape:'javascript'}");
        btn.innerHTML = originalText;
        btn.disabled = false;
      });
  }
})();
</script>
