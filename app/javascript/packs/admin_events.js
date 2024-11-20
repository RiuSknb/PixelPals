document.addEventListener('DOMContentLoaded', function () {
  // すべての削除ボタンにクリックイベントを追加
  const deleteButtons = document.querySelectorAll('.delete-btn');
  
  deleteButtons.forEach(button => {
    button.addEventListener('click', function(event) {
      event.preventDefault();
      
      // 対応する削除理由フォームを取得
      const eventId = this.dataset.eventId;
      const deleteReasonForm = document.getElementById(`delete-reason-form-${eventId}`);
      
      // フォームの表示を切り替え
      if (deleteReasonForm.style.display === 'none' || deleteReasonForm.style.display === '') {
        deleteReasonForm.style.display = 'block';
      } else {
        deleteReasonForm.style.display = 'none';
      }
    });
  });
});