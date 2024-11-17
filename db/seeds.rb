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
