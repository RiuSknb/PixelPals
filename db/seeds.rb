# genresを作成
genres = Genre.create([
  { name: 'RPG' },
  { name: 'STG' },
  { name: 'Sports' }
])

# 各ジャンルに対応するゲームを作成
games = Game.create([
  { genre_id: genres[0].id, name: 'RPG1' },
  { genre_id: genres[0].id, name: 'RPG2' },
  { genre_id: genres[1].id, name: 'STG1' },
  { genre_id: genres[1].id, name: 'STG2' },
  { genre_id: genres[2].id, name: 'sports1' },
  { genre_id: genres[2].id, name: 'sports2' }
])

# 管理者アカウントを作成
admin = Admin.new(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# 管理者アカウントを保存
admin.save!