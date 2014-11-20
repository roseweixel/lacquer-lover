# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
lacquers = Lacquer.create([
    {brand: 'Essie', name: 'Jelly Apple', color: 'red', finish: 'jelly'}, 
    {brand: 'Essie', name: 'Ballet Slippers', color: 'pink', finish: 'sheer'}, 
    {brand: 'OPI', name: 'Louvre Me Louvre Me Not', color: 'purple', finish: 'shimmer'},
    {brand: 'OPI', name: 'Tickle My France-y', color: 'nude', finish: 'creme'},
    {brand: 'Butter London', name: 'The Full Monty', color: 'gold', finish: 'metalic'},
    {brand: 'Deborah Lippmann', name: 'Across the Universe', color: 'blue', finish: 'glitter'}
    ])