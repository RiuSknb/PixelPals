document.addDiaryListener('DOMContentLoaded', function () {
  // すべての削除ボタンにクリックイベントを追加
  const deleteButtons = document.querySelectorAll('.delete-btn');
  
  deleteButtons.forEach(button => {
    button.addDiaryListener('click', function(diary) {
      diary.preventDefault();
      
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
});