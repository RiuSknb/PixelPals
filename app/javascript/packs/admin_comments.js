$(document).on('turbolinks:load', function() {
  // 削除ボタンのクリックイベントを監視
  document.querySelectorAll('.delete-btn').forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault(); // 通常のリンク動作を防止

      // 対応する削除理由フォームを表示
      var commentId = button.getAttribute('data-comment-id');
      var reasonForm = document.getElementById('delete-reason-form-' + commentId);

      // フォームをトグル（表示/非表示）
      if (reasonForm.style.display === 'none' || reasonForm.style.display === '') {
        reasonForm.style.display = 'block';
      } else {
        reasonForm.style.display = 'none';
      }
    });
  });
});