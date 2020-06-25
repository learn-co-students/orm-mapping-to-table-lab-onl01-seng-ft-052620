class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_reader :name, :grade, :id

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT id FROM students WHERE id = (SELECT MAX(id) FROM students);")[0][0]
  end

  def self.create(name:, grade:)
   student = Student.new(name, grade)
   student.save
   student 
  end

end
