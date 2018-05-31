# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

specials = [
    {
        name: 'End game with 9 or more kills',
        code: 'end9',
        bonus: 5.0,
    },
    {
        name: 'Stream my boost',
        code: 'stream',
        bonus: 2.0,
    },
    {
        name: 'I want my old booster',
        code: 'oldbooster',
        bonus: 0.0,
    },
]

Product.create!(
  title: 'Fortnite Elo Boosting',
  price: 10.0,
  description: '',
  specials: specials.to_json
)

if Rails.env.development?
end
