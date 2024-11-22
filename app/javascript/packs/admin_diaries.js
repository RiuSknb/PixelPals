document.addEventListener('turbolinks:load', function () {
  // すべての削除ボタンにクリックイベントを追加
  const deleteButtons = document.querySelectorAll('.delete-btn');
  
  deleteButtons.forEach(button => {
    button.addEventListener('click', function(event) {
      event.preventDefault();  // イベントのデフォルト動作を防ぐ
      
      // 対応する削除理由フォームを取得
      const diaryId = this.dataset.diaryId;
      const deleteReasonForm = document.getElementById(`delete-reason-form-${diaryId}`);
      
      // フォームの表示を切り替え
      if (deleteReasonForm.style.display === 'none' || deleteReasonForm.style.display === '') {
        deleteReasonForm.style.display = 'block';
      } else {
        deleteReasonForm.style.display = 'none';
      }
    });
  });

  // 特定の削除ボタンが固定的な場合（例: 投稿詳細ビュー）
  const singleDeleteButton = document.getElementById("delete-button");
  const singleDeleteForm = document.getElementById("delete-form");

  if (singleDeleteButton && singleDeleteForm) {
    singleDeleteButton.addEventListener("click", function () {
      singleDeleteForm.style.display = singleDeleteForm.style.display === "none" ? "block" : "none";
    });
  }
});