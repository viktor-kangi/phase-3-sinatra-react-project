puts "🌱 Seeding spices..."

# Seed your database here
# Create some users
users = [
  { name: "Alice", email: "alice@example.com", password: "password" },
  { name: "Bob", email: "bob@example.com", password: "password" },
  { name: "Charlie", email: "charlie@example.com", password: "password" }
]

User.create!(users)

# Create some memes for the users
memes = [
  {
    title: "Meme 1",
    description: "This is the first meme",
    url: "https://example.com/meme1.jpg",
    user_id: User.first.id
  },
  {
    title: "Meme 2",
    description: "This is the second meme",
    url: "https://example.com/meme2.jpg",
    user_id: User.second.id
  },
  {
    title: "Meme 3",
    description: "This is the third meme",
    url: "https://example.com/meme3.jpg",
    user_id: User.third.id
  }
]

Meme.create!(memes)


puts "✅ Done seeding!"
