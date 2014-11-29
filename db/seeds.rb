# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

LACQUERS = {
  "Jelly Apple" => {colors: ['red'], finishes: ['jelly']},
  "Ballet Slippers" => {colors: ['pink'], finishes: ['sheer']},
  "Tickle My France-y" => {colors: ['nude'], finishes: ['creme']},
  "Louvre Me Louvre Me Not" => {colors: ['purple'], finishes: ['shimmer']},
  "The Full Monty" => {colors: ['gold'], finishes: ['metalic']},
  "Disco Biscuit" => {colors: ['pink'], finishes: ['glitter', 'jelly']},
  "Across the Universe" => {colors: ['blue', 'green'], finishes: ['glitter']},
  "Mermaid's Dream" => {colors: ['green'], finishes: ['glitter', 'shimmer']}
}

### Create Brands ###
brands = Brand.create([
  {name: 'Essie'},
  {name: 'OPI'},
  {name: 'Butter London'},
  {name: 'Deborah Lippmann'}
])

### Create Colors ###
colors = Color.create([
  {name: 'red'},
  {name: 'orange'},
  {name: 'yellow'},
  {name: 'green'},
  {name: 'blue'},
  {name: 'purple'},
  {name: 'pink'},
  {name: 'grey'},
  {name: 'black'},
  {name: 'white'},
  {name: 'nude'},
  {name: 'gold'},
  {name: 'silver'}
])

### Create Finishes ###
finishes = Finish.create([
  {description: 'sheer'},
  {description: 'creme'},
  {description: 'shimmer'},
  {description: 'glitter'},
  {description: 'jelly'},
  {description: 'metalic'}
])

### Create Lacquers ###

#{brand: 'Essie', name: 'Jelly Apple', color: 'red', finish: 'jelly'} 
#{brand: 'Essie', name: 'Ballet Slippers', color: 'pink', finish: 'sheer'}
essie = Brand.where(name: 'Essie').first
essie.lacquers.create([
  {name: "Jelly Apple"},
  {name: "Ballet Slippers"}
])

opi = Brand.where(name: 'OPI').first
opi.lacquers.create([
  {name: "Tickle My France-y"},
  {name: "Louvre Me Louvre Me Not"}
])

butter = Brand.where(name: 'Butter London').first
butter.lacquers.create([
  {name: "The Full Monty"},
  {name: "Disco Biscuit"}
])

deborah = Brand.where(name: 'Deborah Lippmann').first
deborah.lacquers.create([
  {name: "Across the Universe"},
  {name: "Mermaid's Dream"}
])


### Create LacquerColors && LacquerFinishes ###
LACQUERS.each do |lacquer, attributes_hash|
  lacquer_id = Lacquer.find_by(name: lacquer).id
  attributes_hash[:colors].each do |color|
    color_id = Color.find_by(name: color).id
    LacquerColor.create(lacquer_id: lacquer_id, color_id: color_id)
  end
  attributes_hash[:finishes].each do |finish|
    finish_id = Finish.find_by(description: finish).id
    LacquerFinish.create(lacquer_id: lacquer_id, finish_id: finish_id)
  end
end
