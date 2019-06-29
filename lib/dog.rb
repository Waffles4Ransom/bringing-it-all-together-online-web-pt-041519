class Dog 
  attr_accessor :name, :breed, :id 
  
  def initialize(id: nil, name:, breed:)
    @id, @name, @breed = id, name, breed
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        breed TEXT
        );
      SQL
      
      DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs;")
  end 
  
  def save 
    if self.id
      self.update
    else 
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?,?)
        SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end 
  
  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end
  
  def self.find_by_id(id)
    sql = <<-SQL 
      SELECT * FROM dogs 
      WHERE id = ?
      SQL
      
    DB[:conn].execute(sql, id)
  end 
  
  def self.find_or_create_by
    
  end 
  
  def self.new_from_db(row)
    new_dog = self.new 
    new_dog.id = row[0]
    new_dog.name = row[1]
    new_dog.breed = row[2]
    new_dog
  end 
  
  def self.find_by_name
    sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1"
    
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end 
  end 
  
  def update 
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end 
end 