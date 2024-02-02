class Substance < ActiveRecord::Migration[7.1]
  def self.up
    create_table :substances do |t|
      t.string :names, array: true, default: []
    end

    create_table :substances_interactions do |t|
      t.belongs_to :substance1
      t.belongs_to :substance2
      t.belongs_to :interaction
      t.string :color
    end
  end
  def self.down
  end
end


$sub_matrix.to_a.each do |i|
  i.last.map(&:to_i).each do |ii|
    next if ii == 0
    puts "Creating #{i.first[0]} #{i.first[1]} #{ii}"
    SubstanceInteraction.create(
      interaction_id: Interaction.find_by(number: ii),
      substance1: Substance.find_by(names: [i.first[0]]),
      substance2:  Substance.find_by(names: [i.first[1]])
    )
  end
end
