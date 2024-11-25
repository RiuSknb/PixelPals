document.addEventListener('DOMContentLoaded', () => {
  const userIdInput = document.querySelector('#user_id');
  const userInfoDisplay = document.querySelector('#user-info-display');

  if (userIdInput) {
    userIdInput.addEventListener('input', () => {
      const userId = userIdInput.value;

      if (userId.trim() === '') {
        userInfoDisplay.textContent = ''; // 入力が空の場合は何も表示しない
        return;
      }

      fetch(`/users/find_by_id?id=${userId}`)
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            userInfoDisplay.textContent = `ユーザー名: ${data.name}`;
          } else {
            userInfoDisplay.textContent = `エラー: ${data.error}`;
          }
        })
        .catch(() => {
          userInfoDisplay.textContent = '通信エラーが発生しました';
        });
    });
  }
});